import { Injectable, HttpException, HttpStatus } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import axios, { AxiosInstance } from 'axios';

export interface RxNormConcept {
  rxcui: string;
  name: string;
  synonym: string;
  tty: string;
  language: string;
  suppress: string;
  umlscui: string;
}

export interface DrugInteraction {
  minConceptItem: {
    rxcui: string;
    name: string;
    tty: string;
  };
  interactionTypeGroup: Array<{
    sourceDisclaimer: string;
    sourceName: string;
    interactionType: Array<{
      comment: string;
      minConceptItem: {
        rxcui: string;
        name: string;
        tty: string;
      };
      interactionPair: Array<{
        interactionConcept: Array<{
          minConceptItem: {
            rxcui: string;
            name: string;
            tty: string;
          };
          sourceConceptItem: {
            id: string;
            name: string;
            url: string;
          };
        }>;
        severity: string;
        description: string;
      }>;
    }>;
  }>;
}

export interface MedicationInfo {
  rxcui: string;
  name: string;
  genericName?: string;
  brandNames: string[];
  strength?: string;
  dosageForm?: string;
  route?: string;
  classification?: string;
  ingredients: string[];
}

@Injectable()
export class RxNormService {
  private httpClient: AxiosInstance;
  private readonly baseUrl = 'https://rxnav.nlm.nih.gov/REST';

  constructor(private readonly configService: ConfigService) {
    this.httpClient = axios.create({
      baseURL: this.baseUrl,
      timeout: 10000,
      headers: {
        'Content-Type': 'application/json',
        'User-Agent': 'CareCircle-Medication-Management/1.0',
      },
    });
  }

  async searchMedication(medicationName: string): Promise<RxNormConcept[]> {
    try {
      const response = await this.httpClient.get('/drugs.json', {
        params: {
          name: medicationName,
        },
      });

      const drugGroup = response.data?.drugGroup;
      if (!drugGroup || !drugGroup.conceptGroup) {
        return [];
      }

      const concepts: RxNormConcept[] = [];
      for (const group of drugGroup.conceptGroup) {
        if (group.conceptProperties) {
          concepts.push(...group.conceptProperties);
        }
      }

      return concepts;
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : 'Unknown error';
      throw new HttpException(
        `Failed to search medication: ${errorMessage}`,
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  async getMedicationInfo(rxcui: string): Promise<MedicationInfo | null> {
    try {
      // Get basic concept information
      const conceptResponse = await this.httpClient.get(
        `/rxcui/${rxcui}/properties.json`,
      );
      const properties = conceptResponse.data?.properties;

      if (!properties) {
        return null;
      }

      // Get related concepts (brand names, generic names, etc.)
      const relatedResponse = await this.httpClient.get(
        `/rxcui/${rxcui}/related.json`,
        {
          params: {
            tty: 'SBD+GPCK+BN+SCD',
          },
        },
      );

      const relatedGroup = relatedResponse.data?.relatedGroup;
      const brandNames: string[] = [];
      let genericName: string | undefined;

      if (relatedGroup && relatedGroup.conceptGroup) {
        for (const group of relatedGroup.conceptGroup) {
          if (group.tty === 'BN' && group.conceptProperties) {
            // Brand names
            brandNames.push(
              ...group.conceptProperties.map((prop: any) => prop.name),
            );
          } else if (group.tty === 'IN' && group.conceptProperties) {
            // Generic/ingredient names
            genericName = group.conceptProperties[0]?.name;
          }
        }
      }

      // Get ingredients
      const ingredientsResponse = await this.httpClient.get(
        `/rxcui/${rxcui}/allrelated.json`,
      );
      const ingredients: string[] = [];

      const allRelated = ingredientsResponse.data?.allRelatedGroup;
      if (allRelated && allRelated.conceptGroup) {
        for (const group of allRelated.conceptGroup) {
          if (group.tty === 'IN' && group.conceptProperties) {
            ingredients.push(
              ...group.conceptProperties.map((prop: any) => prop.name),
            );
          }
        }
      }

      return {
        rxcui,
        name: properties.name,
        genericName,
        brandNames,
        strength: properties.strength,
        dosageForm: properties.dosageForm,
        route: properties.route,
        classification: properties.rxtty,
        ingredients: [...new Set(ingredients)], // Remove duplicates
      };
    } catch (error) {
      throw new HttpException(
        `Failed to get medication info: ${error.message}`,
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  async checkDrugInteractions(rxcuis: string[]): Promise<DrugInteraction[]> {
    if (rxcuis.length < 2) {
      return [];
    }

    try {
      const response = await this.httpClient.get('/interaction/list.json', {
        params: {
          rxcuis: rxcuis.join('+'),
        },
      });

      const fullInteractionTypeGroup = response.data?.fullInteractionTypeGroup;
      if (!fullInteractionTypeGroup) {
        return [];
      }

      return fullInteractionTypeGroup;
    } catch (error) {
      throw new HttpException(
        `Failed to check drug interactions: ${error.message}`,
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  async findRxCuiByName(medicationName: string): Promise<string | null> {
    try {
      const concepts = await this.searchMedication(medicationName);

      // Prefer exact matches first
      const exactMatch = concepts.find(
        (concept) =>
          concept.name.toLowerCase() === medicationName.toLowerCase(),
      );

      if (exactMatch) {
        return exactMatch.rxcui;
      }

      // Fall back to first result if available
      return concepts.length > 0 ? concepts[0].rxcui : null;
    } catch (error) {
      throw new HttpException(
        `Failed to find RxCUI: ${error.message}`,
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  async getSpellingCorrections(medicationName: string): Promise<string[]> {
    try {
      const response = await this.httpClient.get('/spellingsuggestions.json', {
        params: {
          name: medicationName,
        },
      });

      const suggestionGroup = response.data?.suggestionGroup;
      if (!suggestionGroup || !suggestionGroup.suggestionList) {
        return [];
      }

      return suggestionGroup.suggestionList.suggestion || [];
    } catch (error) {
      throw new HttpException(
        `Failed to get spelling corrections: ${error.message}`,
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  async getApproximateMatch(
    medicationName: string,
    maxEntries: number = 10,
  ): Promise<RxNormConcept[]> {
    try {
      const response = await this.httpClient.get('/approximateTerm.json', {
        params: {
          term: medicationName,
          maxEntries,
        },
      });

      const approximateGroup = response.data?.approximateGroup;
      if (!approximateGroup || !approximateGroup.candidate) {
        return [];
      }

      return approximateGroup.candidate;
    } catch (error) {
      throw new HttpException(
        `Failed to get approximate matches: ${error.message}`,
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  async validateMedicationName(medicationName: string): Promise<{
    isValid: boolean;
    rxcui?: string;
    suggestions: string[];
    approximateMatches: RxNormConcept[];
  }> {
    try {
      // First try exact search
      const rxcui = await this.findRxCuiByName(medicationName);

      if (rxcui) {
        return {
          isValid: true,
          rxcui,
          suggestions: [],
          approximateMatches: [],
        };
      }

      // Get spelling suggestions and approximate matches
      const [suggestions, approximateMatches] = await Promise.all([
        this.getSpellingCorrections(medicationName),
        this.getApproximateMatch(medicationName, 5),
      ]);

      return {
        isValid: false,
        suggestions,
        approximateMatches,
      };
    } catch (error) {
      throw new HttpException(
        `Failed to validate medication name: ${error.message}`,
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  async analyzeDrugInteractions(
    medications: Array<{ name: string; rxcui?: string }>,
  ): Promise<{
    interactions: DrugInteraction[];
    severityAnalysis: {
      high: number;
      moderate: number;
      low: number;
      unknown: number;
    };
    recommendations: string[];
  }> {
    try {
      // Get RxCUIs for medications that don't have them
      const medicationsWithRxcui = await Promise.all(
        medications.map(async (med) => {
          if (med.rxcui) {
            return { ...med, rxcui: med.rxcui };
          }

          const rxcui = await this.findRxCuiByName(med.name);
          return { ...med, rxcui };
        }),
      );

      // Filter out medications without RxCUIs
      const validRxcuis = medicationsWithRxcui
        .filter((med) => med.rxcui)
        .map((med) => med.rxcui!);

      if (validRxcuis.length < 2) {
        return {
          interactions: [],
          severityAnalysis: { high: 0, moderate: 0, low: 0, unknown: 0 },
          recommendations: [
            'Need at least 2 valid medications to check interactions',
          ],
        };
      }

      // Check interactions
      const interactions = await this.checkDrugInteractions(validRxcuis);

      // Analyze severity
      const severityAnalysis = { high: 0, moderate: 0, low: 0, unknown: 0 };
      const recommendations: string[] = [];

      for (const interaction of interactions) {
        for (const typeGroup of interaction.interactionTypeGroup) {
          for (const type of typeGroup.interactionType) {
            for (const pair of type.interactionPair) {
              const severity = pair.severity?.toLowerCase();

              switch (severity) {
                case 'high':
                case 'major':
                  severityAnalysis.high++;
                  recommendations.push(`HIGH SEVERITY: ${pair.description}`);
                  break;
                case 'moderate':
                case 'medium':
                  severityAnalysis.moderate++;
                  recommendations.push(`MODERATE: ${pair.description}`);
                  break;
                case 'low':
                case 'minor':
                  severityAnalysis.low++;
                  break;
                default:
                  severityAnalysis.unknown++;
              }
            }
          }
        }
      }

      if (severityAnalysis.high > 0) {
        recommendations.unshift(
          '⚠️ HIGH SEVERITY interactions detected - Consult healthcare provider immediately',
        );
      } else if (severityAnalysis.moderate > 0) {
        recommendations.unshift(
          '⚠️ MODERATE interactions detected - Monitor closely and consult healthcare provider',
        );
      }

      return {
        interactions,
        severityAnalysis,
        recommendations,
      };
    } catch (error) {
      throw new HttpException(
        `Failed to analyze drug interactions: ${error.message}`,
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }
}
