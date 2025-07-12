import { Injectable, Logger } from '@nestjs/common';
import { StateGraph, MessagesAnnotation, Command } from '@langchain/langgraph';
import { ChatOpenAI } from '@langchain/openai';
import { z } from 'zod';
import { BaseMessage, HumanMessage, AIMessage } from '@langchain/core/messages';
import {
  BaseHealthcareAgent,
  HealthcareContext,
  AgentResponse,
  AgentCapability,
} from './base-healthcare.agent';
import { PHIProtectionService } from '../../../common/compliance/phi-protection.service';
import { VietnameseNLPIntegrationService } from '../../infrastructure/services/vietnamese-nlp-integration.service';

export interface QueryClassification {
  primaryIntent:
    | 'medication'
    | 'emergency'
    | 'clinical'
    | 'general'
    | 'vietnamese_medical';
  urgencyLevel: number; // 0.0-1.0
  culturalContext: 'traditional' | 'modern' | 'mixed';
  requiredAgents: string[];
  medicalEntities: Array<{
    type: string;
    value: string;
    confidence: number;
  }>;
  languagePreference: 'vietnamese' | 'english' | 'mixed';
  confidence: number;
  reasoning: string;
}

export interface AgentHandoff {
  fromAgent: string;
  toAgent: string;
  context: HealthcareContext;
  reason: string;
  urgency: number;
  preservedState: any;
}

@Injectable()
export class HealthcareSupervisorAgent extends BaseHealthcareAgent {
  protected readonly logger = new Logger(HealthcareSupervisorAgent.name);
  private stateGraph: any;

  constructor(
    phiProtectionService: PHIProtectionService,
    vietnameseNLPService: VietnameseNLPIntegrationService,
  ) {
    super('healthcare_supervisor', phiProtectionService, vietnameseNLPService, {
      modelName: 'gpt-4',
      temperature: 0.1, // Low temperature for consistent routing decisions
      maxTokens: 2000,
    });

    this.initializeStateGraph();
  }

  protected defineCapabilities(): AgentCapability[] {
    return [
      {
        name: 'Healthcare Query Analysis',
        description:
          'Analyze and classify healthcare queries for appropriate agent routing',
        confidence: 0.95,
        requiresPhysicianReview: false,
        maxSeverityLevel: 10, // Can handle all severity levels for routing
        supportedLanguages: ['vietnamese', 'english', 'mixed'],
        medicalSpecialties: ['all'], // Supervisor handles all specialties for routing
      },
      {
        name: 'Agent Coordination',
        description: 'Coordinate between specialized healthcare agents',
        confidence: 0.9,
        requiresPhysicianReview: false,
        maxSeverityLevel: 10,
        supportedLanguages: ['vietnamese', 'english', 'mixed'],
        medicalSpecialties: ['all'],
      },
      {
        name: 'Emergency Detection',
        description:
          'Detect emergency situations and route to appropriate care',
        confidence: 0.85,
        requiresPhysicianReview: true,
        maxSeverityLevel: 10,
        supportedLanguages: ['vietnamese', 'english', 'mixed'],
        medicalSpecialties: ['emergency_medicine'],
      },
    ];
  }

  private initializeStateGraph() {
    // Simplified state graph implementation
    this.stateGraph = {
      invoke: async (initialState: any) => {
        // Step 1: Analyze query
        const classification = await this.analyzeQuery(initialState);

        // Step 2: Route to appropriate agent
        const routedAgent = await this.routeToAgent({ ...initialState, classification });

        // Step 3: Coordinate response
        const finalResult = await this.coordinateResponse({
          ...initialState,
          classification,
          routedAgent
        });

        return finalResult;
      }
    };
  }

  protected async processAgentSpecificQuery(
    query: string,
    context: HealthcareContext,
  ): Promise<AgentResponse> {
    const startTime = Date.now();
    try {
      this.logger.log(
        `Supervisor processing query: ${query.substring(0, 100)}...`,
      );

      // Initialize state with user message and context
      const initialState = {
        messages: [new HumanMessage({ content: query })],
        healthcareContext: context,
        urgencyLevel: 0,
        agentType: 'supervisor',
        complianceFlags: [],
      };

      // Execute the supervisor workflow
      const result = await this.stateGraph.invoke(initialState);

      // Extract the final response
      const lastMessage = result.messages[
        result.messages.length - 1
      ] as AIMessage;

      return {
        agentType: 'healthcare_supervisor',
        response: lastMessage.content as string,
        confidence: 0.9,
        urgencyLevel: result.urgencyLevel || 0.5,
        requiresEscalation: result.urgencyLevel >= 0.8,
        metadata: {
          urgencyLevel: result.urgencyLevel,
          agentType: result.agentType,
          complianceFlags: result.complianceFlags || [],
          processingTime: Date.now() - startTime,
          modelUsed: 'gpt-4',
          tokensConsumed: 0,
          costUsd: 0,
          phiDetected: false,
          routedToAgent: result.agentType,
          classification: result.classification,
        },
      };
    } catch (error) {
      this.logger.error('Supervisor agent processing failed:', error);
      throw new Error(
        `Healthcare supervisor processing failed: ${error.message}`,
      );
    }
  }

  private async analyzeQuery(state: any): Promise<QueryClassification> {
    const query = state.messages[0].content as string;

    try {
      const classification = await this.classifyHealthcareQuery(query);
      return classification;
    } catch (error) {
      this.logger.error('Query analysis failed:', error);
      // Fallback to general classification
      return {
        primaryIntent: 'general',
        urgencyLevel: 0.3,
        culturalContext: 'mixed',
        requiredAgents: ['general'],
        medicalEntities: [],
        languagePreference: 'english',
        confidence: 0.5,
        reasoning: 'Fallback classification due to analysis error',
      };
    }
  }

  private async routeToAgent(state: any): Promise<string> {
    const classification = state.classification as QueryClassification;

    // Determine the appropriate agent based on classification
    let targetAgent = 'general';

    if (classification.urgencyLevel >= 0.8) {
      targetAgent = 'emergency_agent';
    } else if (classification.primaryIntent === 'medication') {
      targetAgent = 'medication_agent';
    } else if (classification.primaryIntent === 'vietnamese_medical') {
      targetAgent = 'vietnamese_medical_agent';
    } else if (classification.primaryIntent === 'clinical') {
      targetAgent = 'clinical_agent';
    }

    this.logger.log(
      `Routing query to: ${targetAgent} (urgency: ${classification.urgencyLevel})`,
    );

    return targetAgent;
  }

  private async coordinateResponse(state: any): Promise<any> {
    const classification = state.classification as QueryClassification;
    const routedAgent = state.routedAgent as string;

    // Generate supervisor response with routing information
    const supervisorResponse = this.generateSupervisorResponse(
      classification,
      routedAgent,
    );

    return {
      messages: [
        new AIMessage({
          content: supervisorResponse,
          name: 'healthcare_supervisor',
        }),
      ],
      agentType: 'healthcare_supervisor',
      finalAgent: routedAgent,
      urgencyLevel: classification.urgencyLevel,
      classification,
      complianceFlags: [],
    };
  }

  private async classifyHealthcareQuery(
    query: string,
  ): Promise<QueryClassification> {
    const analysisPrompt = `Analyze this healthcare query and classify it for routing to specialized agents:

Query: "${query}"

Classify into one of:
- medication: Drug interactions, dosing, adherence, side effects, prescriptions
- emergency: Urgent symptoms, severe pain, breathing issues, chest pain, loss of consciousness
- clinical: Diagnosis support, symptoms analysis, medical guidance, health monitoring
- vietnamese_medical: Vietnamese language queries, traditional medicine, cultural healthcare
- general: Basic health questions, wellness advice, general information

Also assess:
- urgency (0.0-1.0): 0.9-1.0 = life-threatening, 0.7-0.8 = urgent care, 0.5-0.6 = routine, 0.0-0.4 = general
- cultural context: traditional (thuốc nam focus), modern (western medicine), mixed
- language preference: vietnamese, english, mixed
- medical entities: extract symptoms, conditions, medications mentioned

Provide detailed reasoning for the classification.`;

    const response = await this.model.invoke([
      { role: 'system', content: analysisPrompt },
      { role: 'user', content: query },
    ]);

    return this.parseClassificationResponse(response.content as string, query);
  }

  private parseClassificationResponse(
    content: string,
    originalQuery: string,
  ): QueryClassification {
    // Extract classification information from the response
    // This is a simplified parser - in production, you might want to use structured output

    const primaryIntent = this.extractIntent(content);
    const urgencyLevel = this.extractUrgency(content, originalQuery);
    const culturalContext = this.extractCulturalContext(content, originalQuery);
    const languagePreference = this.detectLanguage(originalQuery);

    return {
      primaryIntent,
      urgencyLevel,
      culturalContext,
      requiredAgents: [primaryIntent],
      medicalEntities: this.extractMedicalEntitiesForClassification(originalQuery),
      languagePreference,
      confidence: 0.8,
      reasoning: content,
    };
  }

  private extractIntent(content: string): QueryClassification['primaryIntent'] {
    const contentLower = content.toLowerCase();

    if (
      contentLower.includes('medication') ||
      contentLower.includes('drug') ||
      contentLower.includes('prescription')
    ) {
      return 'medication';
    }
    if (
      contentLower.includes('emergency') ||
      contentLower.includes('urgent') ||
      contentLower.includes('severe')
    ) {
      return 'emergency';
    }
    if (
      contentLower.includes('vietnamese') ||
      contentLower.includes('traditional') ||
      contentLower.includes('thuốc nam')
    ) {
      return 'vietnamese_medical';
    }
    if (
      contentLower.includes('clinical') ||
      contentLower.includes('diagnosis') ||
      contentLower.includes('symptom')
    ) {
      return 'clinical';
    }

    return 'general';
  }

  private extractUrgency(content: string, query: string): number {
    const emergencyKeywords = [
      'chest pain',
      'difficulty breathing',
      'severe bleeding',
      'unconscious',
      'stroke',
      'heart attack',
      'allergic reaction',
      'overdose',
      'cấp cứu',
      'khẩn cấp',
      'nguy hiểm',
      'nghiêm trọng',
      'đau dữ dội',
    ];

    const queryLower = query.toLowerCase();
    const urgencyScore = emergencyKeywords.reduce((score, keyword) => {
      return queryLower.includes(keyword) ? score + 0.2 : score;
    }, 0);

    return Math.min(urgencyScore, 1.0);
  }

  private extractCulturalContext(
    content: string,
    query: string,
  ): QueryClassification['culturalContext'] {
    const traditionalKeywords = [
      'thuốc nam',
      'đông y',
      'y học cổ truyền',
      'traditional medicine',
    ];
    const queryLower = query.toLowerCase();

    const hasTraditional = traditionalKeywords.some((keyword) =>
      queryLower.includes(keyword),
    );
    const hasVietnamese =
      /[àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ]/.test(
        query,
      );

    if (hasTraditional) return 'traditional';
    if (hasVietnamese) return 'mixed';
    return 'modern';
  }

  protected extractMedicalEntities(
    text: string,
  ): Array<{ text: string; type: string; confidence: number }> {
    // Basic medical entity extraction - in production, this would use NLP services
    const entities: Array<{ text: string; type: string; confidence: number }> =
      [];

    // Common symptoms
    const symptoms = [
      'headache',
      'fever',
      'cough',
      'pain',
      'đau đầu',
      'sốt',
      'ho',
      'đau',
    ];
    symptoms.forEach((symptom) => {
      if (text.toLowerCase().includes(symptom)) {
        entities.push({ text: symptom, type: 'symptom', confidence: 0.8 });
      }
    });

    return entities;
  }

  private extractMedicalEntitiesForClassification(
    text: string,
  ): Array<{ type: string; value: string; confidence: number }> {
    const baseEntities = this.extractMedicalEntities(text);
    return baseEntities.map(entity => ({
      type: entity.type,
      value: entity.text,
      confidence: entity.confidence
    }));
  }

  private generateSupervisorResponse(
    classification: QueryClassification,
    routedAgent: string,
  ): string {
    const urgencyText =
      classification.urgencyLevel >= 0.8
        ? 'high priority'
        : classification.urgencyLevel >= 0.5
          ? 'moderate priority'
          : 'routine';

    return (
      `I've analyzed your healthcare query and classified it as ${classification.primaryIntent} with ${urgencyText} urgency. ` +
      `I'm routing this to our ${routedAgent.replace('_', ' ')} specialist for the most appropriate care. ` +
      `${classification.urgencyLevel >= 0.8 ? 'This appears to require urgent attention. ' : ''}` +
      `Please wait while I connect you with the appropriate healthcare specialist.`
    );
  }
}
