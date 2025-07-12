import { Injectable, Logger } from '@nestjs/common';
import { StateGraph, MessagesAnnotation, Command } from '@langchain/langgraph';
import { ChatOpenAI } from '@langchain/openai';
import { z } from 'zod';
import { BaseMessage, HumanMessage, AIMessage } from '@langchain/core/messages';
import { HealthcareSupervisorAgent } from '../../domain/agents/healthcare-supervisor.agent';
import { VietnameseMedicalAgent } from '../../domain/agents/vietnamese-medical.agent';
import { MedicationManagementAgent } from '../../domain/agents/medication-management.agent';
import { EmergencyTriageAgent } from '../../domain/agents/emergency-triage.agent';
import { ClinicalDecisionSupportAgent } from '../../domain/agents/clinical-decision-support.agent';
import {
  HealthcareContext,
  AgentResponse,
} from '../../domain/agents/base-healthcare.agent';

// Types for healthcare agent system - using types from base agent

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
  medicalEntities: Array<{ type: string; value: string; confidence: number }>;
  languagePreference: 'vietnamese' | 'english' | 'mixed';
  confidence?: number; // Optional confidence score
  reasoning?: string; // Optional reasoning text
}

@Injectable()
export class HealthcareAgentOrchestratorService {
  private readonly logger = new Logger(HealthcareAgentOrchestratorService.name);
  private model: ChatOpenAI;
  private stateGraph: any; // Compiled StateGraph

  constructor(
    private readonly supervisorAgent: HealthcareSupervisorAgent,
    private readonly vietnameseMedicalAgent: VietnameseMedicalAgent,
    private readonly medicationAgent: MedicationManagementAgent,
    private readonly emergencyAgent: EmergencyTriageAgent,
    private readonly clinicalAgent: ClinicalDecisionSupportAgent,
  ) {
    this.model = new ChatOpenAI({
      modelName: 'gpt-4',
      temperature: 0.1, // Low temperature for consistent medical routing
    });
    this.initializeAgentGraph();
  }

  private initializeAgentGraph() {
    const graph = new StateGraph(MessagesAnnotation)
      .addNode('supervisor', this.handleSupervisorAgent.bind(this), {
        ends: [
          'medication_agent',
          'emergency_agent',
          'clinical_agent',
          'vietnamese_medical_agent',
          '__end__',
        ],
      })
      .addNode('medication_agent', this.handleMedicationAgent.bind(this), {
        ends: ['supervisor', '__end__'],
      })
      .addNode('emergency_agent', this.handleEmergencyAgent.bind(this), {
        ends: ['supervisor', '__end__'],
      })
      .addNode('clinical_agent', this.handleClinicalAgent.bind(this), {
        ends: ['supervisor', '__end__'],
      })
      .addNode(
        'vietnamese_medical_agent',
        this.handleVietnameseMedicalAgent.bind(this),
        {
          ends: ['supervisor', '__end__'],
        },
      )
      .addEdge('__start__', 'supervisor');

    this.stateGraph = graph.compile();
  }

  async processHealthcareQuery(
    query: string,
    healthcareContext: Partial<HealthcareContext> = {},
  ): Promise<AgentResponse> {
    try {
      this.logger.log(
        `Processing healthcare query: ${query.substring(0, 100)}...`,
      );

      // Initialize state with user message and context
      const initialState = {
        messages: [new HumanMessage({ content: query })],
        healthcareContext,
        urgencyLevel: 0,
        agentType: 'supervisor',
        complianceFlags: [],
      };

      // Execute the agent workflow
      const result = await this.stateGraph.invoke(initialState);

      // Extract the final response
      const lastMessage = result.messages[
        result.messages.length - 1
      ] as AIMessage;

      return {
        agentType: result.agentType || 'supervisor',
        response: lastMessage.content as string,
        confidence: 0.9, // TODO: Implement proper confidence scoring
        urgencyLevel: result.urgencyLevel || 0.5,
        requiresEscalation: result.urgencyLevel > 0.7,
        metadata: {
          processingTime: Date.now(),
          modelUsed: 'gpt-4',
          tokensConsumed: 0,
          costUsd: 0,
          phiDetected: false,
          urgencyLevel: result.urgencyLevel,
          agentsInvolved: this.extractAgentsFromMessages(result.messages),
          complianceFlags: result.complianceFlags || [],
        },
      };
    } catch (error) {
      this.logger.error('Error processing healthcare query:', error);
      throw new Error('Failed to process healthcare query');
    }
  }

  private async handleSupervisorAgent(
    state: typeof MessagesAnnotation.State,
  ): Promise<Command> {
    const lastMessage = state.messages[state.messages.length - 1];
    const query = lastMessage.content as string;
    const healthcareContext = (state as any)
      .healthcareContext as HealthcareContext;

    try {
      // Use the domain supervisor agent
      const response = await this.supervisorAgent.processQuery(
        query,
        healthcareContext,
      );

      // Extract routing decision from supervisor response
      const routedAgent = this.extractRoutedAgent(response.metadata);

      return new Command({
        goto: routedAgent || '__end__',
        update: {
          messages: [
            new AIMessage({ content: response.response, name: 'supervisor' }),
          ],
          agentType: 'supervisor',
          urgencyLevel: response.metadata.urgencyLevel || 0,
          supervisorResponse: response,
        },
      });
    } catch (error) {
      this.logger.error('Supervisor agent failed:', error);
      return new Command({
        goto: '__end__',
        update: {
          messages: [
            new AIMessage({
              content:
                'I apologize, but I encountered an issue processing your request. Please try again or contact support.',
              name: 'supervisor',
            }),
          ],
          agentType: 'supervisor',
          error: error.message,
        },
      });
    }
  }

  private async handleMedicationAgent(
    state: typeof MessagesAnnotation.State,
  ): Promise<Command> {
    const lastMessage = state.messages[state.messages.length - 1];
    const query = lastMessage.content as string;
    const healthcareContext = (state as any)
      .healthcareContext as HealthcareContext;

    try {
      const response = await this.medicationAgent.processQuery(
        query,
        healthcareContext,
      );

      return new Command({
        goto: response.requiresEscalation ? 'supervisor' : '__end__',
        update: {
          messages: [
            new AIMessage({
              content: response.response,
              name: 'medication_agent',
            }),
          ],
          agentType: 'medication_agent',
          finalResponse: response,
        },
      });
    } catch (error) {
      this.logger.error('Medication agent failed:', error);
      return new Command({
        goto: '__end__',
        update: {
          messages: [
            new AIMessage({
              content:
                'I encountered an issue with medication analysis. Please consult with a healthcare provider.',
              name: 'medication_agent',
            }),
          ],
          agentType: 'medication_agent',
          error: error.message,
        },
      });
    }
  }

  private async handleEmergencyAgent(
    state: typeof MessagesAnnotation.State,
  ): Promise<Command> {
    const lastMessage = state.messages[state.messages.length - 1];
    const query = lastMessage.content as string;
    const healthcareContext = (state as any)
      .healthcareContext as HealthcareContext;

    try {
      const response = await this.emergencyAgent.processQuery(
        query,
        healthcareContext,
      );

      return new Command({
        goto: '__end__', // Emergency agent always ends the flow
        update: {
          messages: [
            new AIMessage({
              content: response.response,
              name: 'emergency_agent',
            }),
          ],
          agentType: 'emergency_agent',
          urgencyLevel: response.metadata.severityScore || 1.0,
          finalResponse: response,
        },
      });
    } catch (error) {
      this.logger.error('Emergency agent failed:', error);
      return new Command({
        goto: '__end__',
        update: {
          messages: [
            new AIMessage({
              content:
                '🚨 If this is a medical emergency, call 911 (US) or 115 (Vietnam) immediately. I encountered a technical issue.',
              name: 'emergency_agent',
            }),
          ],
          agentType: 'emergency_agent',
          error: error.message,
        },
      });
    }
  }

  private async handleClinicalAgent(
    state: typeof MessagesAnnotation.State,
  ): Promise<Command> {
    const lastMessage = state.messages[state.messages.length - 1];
    const query = lastMessage.content as string;
    const healthcareContext = (state as any)
      .healthcareContext as HealthcareContext;

    try {
      const response = await this.clinicalAgent.processQuery(
        query,
        healthcareContext,
      );

      return new Command({
        goto: response.requiresEscalation ? 'supervisor' : '__end__',
        update: {
          messages: [
            new AIMessage({
              content: response.response,
              name: 'clinical_agent',
            }),
          ],
          agentType: 'clinical_agent',
          finalResponse: response,
        },
      });
    } catch (error) {
      this.logger.error('Clinical agent failed:', error);
      return new Command({
        goto: '__end__',
        update: {
          messages: [
            new AIMessage({
              content:
                'I encountered an issue with clinical analysis. Please consult with a healthcare provider.',
              name: 'clinical_agent',
            }),
          ],
          agentType: 'clinical_agent',
          error: error.message,
        },
      });
    }
  }

  private async handleVietnameseMedicalAgent(
    state: typeof MessagesAnnotation.State,
  ): Promise<Command> {
    const lastMessage = state.messages[state.messages.length - 1];
    const query = lastMessage.content as string;
    const healthcareContext = (state as any)
      .healthcareContext as HealthcareContext;

    try {
      const response = await this.vietnameseMedicalAgent.processQuery(
        query,
        healthcareContext,
      );

      return new Command({
        goto: response.requiresEscalation ? 'supervisor' : '__end__',
        update: {
          messages: [
            new AIMessage({
              content: response.response,
              name: 'vietnamese_medical_agent',
            }),
          ],
          agentType: 'vietnamese_medical_agent',
          finalResponse: response,
        },
      });
    } catch (error) {
      this.logger.error('Vietnamese medical agent failed:', error);
      return new Command({
        goto: '__end__',
        update: {
          messages: [
            new AIMessage({
              content:
                'Tôi gặp sự cố kỹ thuật. Vui lòng tham khảo ý kiến bác sĩ. / I encountered a technical issue. Please consult with a healthcare provider.',
              name: 'vietnamese_medical_agent',
            }),
          ],
          agentType: 'vietnamese_medical_agent',
          error: error.message,
        },
      });
    }
  }

  private extractRoutedAgent(metadata: any): string {
    // Extract the routed agent from supervisor metadata
    if (metadata.routedToAgent) {
      const agentMap: Record<string, string> = {
        medication_agent: 'medication_agent',
        emergency_agent: 'emergency_agent',
        clinical_agent: 'clinical_agent',
        vietnamese_medical_agent: 'vietnamese_medical_agent',
        general: '__end__',
      };
      return agentMap[metadata.routedToAgent] || '__end__';
    }

    // Fallback based on urgency level
    if (metadata.urgencyLevel >= 0.8) {
      return 'emergency_agent';
    }

    return '__end__';
  }

  private async analyzeQuery(query: string): Promise<QueryClassification> {
    const analysisSchema = z.object({
      primaryIntent: z.enum([
        'medication',
        'emergency',
        'clinical',
        'general',
        'vietnamese_medical',
      ]),
      urgencyLevel: z.number().min(0).max(1),
      culturalContext: z.enum(['traditional', 'modern', 'mixed']),
      requiredAgents: z.array(z.string()),
      medicalEntities: z.array(
        z.object({
          type: z.string(),
          value: z.string(),
          confidence: z.number(),
        }),
      ),
      languagePreference: z.enum(['vietnamese', 'english', 'mixed']),
    });

    const analysisPrompt = `Analyze this healthcare query and classify it:

Query: "${query}"

Provide a JSON response with:
- primaryIntent: medication, emergency, clinical, general, or vietnamese_medical
- urgencyLevel: 0.0-1.0 (0=routine, 1=emergency)
- culturalContext: traditional, modern, or mixed
- requiredAgents: array of agent names needed
- medicalEntities: extracted medical terms with confidence
- languagePreference: vietnamese, english, or mixed

Emergency indicators: chest pain, difficulty breathing, severe bleeding, unconscious, stroke symptoms
Medication indicators: drug names, dosage, interactions, side effects
Vietnamese indicators: Vietnamese text, traditional medicine terms, cultural references`;

    try {
      const response = await this.model.invoke([
        { role: 'system', content: analysisPrompt },
        { role: 'user', content: query },
      ]);

      // Parse the response manually for now
      const content = response.content as string;

      return {
        primaryIntent: this.extractIntent(content),
        urgencyLevel: this.extractUrgency(content),
        culturalContext: this.extractCulturalContext(content),
        requiredAgents: this.extractRequiredAgents(content),
        medicalEntities: [], // TODO: Implement medical entity extraction
        languagePreference:
          content.includes('vietnamese') || content.includes('tiếng việt')
            ? 'vietnamese'
            : 'english',
        confidence: 0.8,
        reasoning: content,
      };
    } catch (error) {
      this.logger.warn(
        'Failed to analyze query, using default classification:',
        error,
      );
      return {
        primaryIntent: 'general',
        urgencyLevel: 0.3,
        culturalContext: 'modern',
        requiredAgents: ['clinical_agent'],
        medicalEntities: [],
        languagePreference: 'english',
      };
    }
  }

  private extractAgentsFromMessages(messages: BaseMessage[]): string[] {
    const agents = new Set<string>();
    messages.forEach((message) => {
      if (message.name) {
        agents.add(message.name);
      }
    });
    return Array.from(agents);
  }

  private extractIntent(content: string): QueryClassification['primaryIntent'] {
    const lowerContent = content.toLowerCase();

    if (
      lowerContent.includes('emergency') ||
      lowerContent.includes('urgent') ||
      lowerContent.includes('chest pain') ||
      lowerContent.includes('difficulty breathing')
    ) {
      return 'emergency';
    }
    if (
      lowerContent.includes('medication') ||
      lowerContent.includes('drug') ||
      lowerContent.includes('dosage') ||
      lowerContent.includes('side effect')
    ) {
      return 'medication';
    }
    if (
      lowerContent.includes('vietnamese') ||
      lowerContent.includes('traditional medicine') ||
      lowerContent.includes('thuốc nam')
    ) {
      return 'vietnamese_medical';
    }
    if (
      lowerContent.includes('symptom') ||
      lowerContent.includes('diagnosis') ||
      lowerContent.includes('clinical')
    ) {
      return 'clinical';
    }
    return 'general';
  }

  private extractUrgency(content: string): number {
    const lowerContent = content.toLowerCase();

    // Emergency indicators
    if (
      lowerContent.includes('emergency') ||
      lowerContent.includes('urgent') ||
      lowerContent.includes('chest pain') ||
      lowerContent.includes('difficulty breathing') ||
      lowerContent.includes('severe bleeding') ||
      lowerContent.includes('unconscious')
    ) {
      return 0.9;
    }

    // High priority indicators
    if (
      lowerContent.includes('pain') ||
      lowerContent.includes('fever') ||
      lowerContent.includes('nausea') ||
      lowerContent.includes('dizziness')
    ) {
      return 0.6;
    }

    // Medium priority
    if (lowerContent.includes('symptom') || lowerContent.includes('concern')) {
      return 0.4;
    }

    // Low priority
    return 0.2;
  }

  private extractCulturalContext(
    content: string,
  ): QueryClassification['culturalContext'] {
    const lowerContent = content.toLowerCase();

    if (
      lowerContent.includes('traditional') ||
      lowerContent.includes('thuốc nam') ||
      lowerContent.includes('herbal') ||
      lowerContent.includes('folk medicine')
    ) {
      return 'traditional';
    }
    if (
      lowerContent.includes('modern') ||
      lowerContent.includes('western medicine') ||
      lowerContent.includes('clinical')
    ) {
      return 'modern';
    }
    return 'mixed';
  }

  private extractRequiredAgents(content: string): string[] {
    const lowerContent = content.toLowerCase();
    const agents: string[] = [];

    if (lowerContent.includes('emergency') || lowerContent.includes('urgent')) {
      agents.push('emergency_agent');
    }
    if (lowerContent.includes('medication') || lowerContent.includes('drug')) {
      agents.push('medication_agent');
    }
    if (
      lowerContent.includes('vietnamese') ||
      lowerContent.includes('traditional')
    ) {
      agents.push('vietnamese_medical_agent');
    }
    if (
      lowerContent.includes('symptom') ||
      lowerContent.includes('diagnosis')
    ) {
      agents.push('clinical_agent');
    }

    // Default to clinical agent if no specific agent identified
    if (agents.length === 0) {
      agents.push('clinical_agent');
    }

    return agents;
  }
}
