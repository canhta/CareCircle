import { Injectable, Logger } from '@nestjs/common';
import { StateGraph, MessagesAnnotation, Command } from '@langchain/langgraph';
import { ChatOpenAI } from '@langchain/openai';
import { z } from 'zod';
import { BaseMessage, HumanMessage, AIMessage } from '@langchain/core/messages';
import { VietnameseMedicalAgentService } from './vietnamese-medical-agent.service';
import { MedicationManagementAgentService } from './medication-management-agent.service';
import { EmergencyTriageAgentService } from './emergency-triage-agent.service';
import { ClinicalDecisionSupportAgentService } from './clinical-decision-support-agent.service';

// Types for healthcare agent system
export interface HealthcareContext {
  patientId?: string;
  age?: number;
  gender?: 'male' | 'female' | 'other';
  medicalHistory?: string[];
  currentMedications?: string[];
  allergies?: string[];
  vitalSigns?: {
    bloodPressure?: string;
    heartRate?: number;
    temperature?: number;
  };
}

export interface AgentResponse {
  agentType: string;
  response: string;
  confidence: number;
  requiresEscalation: boolean;
  metadata: Record<string, any>;
}

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

  constructor() {
    this.model = new ChatOpenAI({
      modelName: 'gpt-4',
      temperature: 0.1, // Low temperature for consistent medical routing
    });
    this.initializeAgentGraph();
  }

  private initializeAgentGraph() {
    const graph = new StateGraph(MessagesAnnotation)
      .addNode('supervisor', this.supervisorAgent.bind(this), {
        ends: [
          'medication_agent',
          'emergency_agent',
          'clinical_agent',
          'vietnamese_medical_agent',
          '__end__',
        ],
      })
      .addNode('medication_agent', this.medicationAgent.bind(this), {
        ends: ['supervisor', '__end__'],
      })
      .addNode('emergency_agent', this.emergencyAgent.bind(this), {
        ends: ['supervisor', '__end__'],
      })
      .addNode('clinical_agent', this.clinicalAgent.bind(this), {
        ends: ['supervisor', '__end__'],
      })
      .addNode(
        'vietnamese_medical_agent',
        this.vietnameseMedicalAgent.bind(this),
        {
          ends: ['supervisor', '__end__'],
        },
      )
      .addEdge('__start__', 'supervisor');

    this.stateGraph = graph.compile();
  }

  async processHealthcareQuery(
    query: string,
    healthcareContext: HealthcareContext = {},
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
        requiresEscalation: result.urgencyLevel > 0.7,
        metadata: {
          processingTime: Date.now(),
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

  private async supervisorAgent(
    state: typeof MessagesAnnotation.State,
  ): Promise<Command> {
    const lastMessage = state.messages[state.messages.length - 1];
    const query = lastMessage.content as string;

    // Analyze the query to determine routing
    const classification = await this.analyzeQuery(query);

    // Create system prompt for supervisor
    const systemPrompt = `You are a healthcare supervisor AI coordinating specialized medical agents. 
    Analyze this query and determine the appropriate specialist agent to handle it.
    
    Query: "${query}"
    Classification: ${JSON.stringify(classification)}
    
    Available agents:
    - medication_agent: Drug interactions, dosing, adherence, side effects
    - emergency_agent: Urgent symptoms, severe conditions, immediate care
    - clinical_agent: Diagnosis support, symptoms analysis, medical guidance
    - vietnamese_medical_agent: Vietnamese medical terminology, traditional medicine integration
    
    Respond with your analysis and route to the appropriate agent.`;

    const response = await this.model.invoke([
      { role: 'system', content: systemPrompt },
      { role: 'user', content: query },
    ]);

    // Determine routing based on classification
    let nextAgent = '__end__';
    if (classification.urgencyLevel >= 0.8) {
      nextAgent = 'emergency_agent';
    } else if (classification.primaryIntent === 'medication') {
      nextAgent = 'medication_agent';
    } else if (classification.primaryIntent === 'vietnamese_medical') {
      nextAgent = 'vietnamese_medical_agent';
    } else if (classification.primaryIntent === 'clinical') {
      nextAgent = 'clinical_agent';
    }

    return new Command({
      goto: nextAgent,
      update: {
        messages: [
          new AIMessage({
            content: response.content as string,
            name: 'supervisor',
          }),
        ],
        urgencyLevel: classification.urgencyLevel,
        agentType: 'supervisor',
      },
    });
  }

  private async medicationAgent(
    state: typeof MessagesAnnotation.State,
  ): Promise<Command> {
    const query = state.messages[0].content as string;

    const medicationPrompt = `You are a specialized medication management AI assistant with expertise in Vietnamese healthcare.
    Provide expert guidance on medications, drug interactions, dosing, and adherence.

    Query: "${query}"

    Focus on:
    - Drug interaction analysis with Vietnamese medications
    - Dosage recommendations considering local practices
    - Side effect information and management
    - Medication adherence strategies for Vietnamese patients
    - Integration with traditional medicine when appropriate

    Always include appropriate medical disclaimers and emphasize the need for professional consultation.`;

    const response = await this.model.invoke([
      { role: 'system', content: medicationPrompt },
      { role: 'user', content: query },
    ]);

    return new Command({
      goto: '__end__',
      update: {
        messages: [
          new AIMessage({
            content: response.content as string,
            name: 'medication_agent',
          }),
        ],
        agentType: 'medication',
      },
    });
  }

  private async emergencyAgent(
    state: typeof MessagesAnnotation.State,
  ): Promise<Command> {
    const query = state.messages[0].content as string;

    const emergencyPrompt = `You are an emergency triage AI assistant specializing in Vietnamese healthcare emergency protocols.
    Assess the urgency of symptoms and provide immediate guidance.

    Query: "${query}"

    CRITICAL: If this appears to be a medical emergency, immediately advise:
    "This may be a medical emergency. Please call emergency services (115 in Vietnam, 911 in US) or go to the nearest emergency room immediately."

    Vietnamese Emergency Contacts:
    - 115: Medical Emergency
    - 113: Police
    - 114: Fire Department
    - 1900 4595: Poison Control Center

    Assess severity and provide appropriate guidance while emphasizing the need for professional medical care.
    Provide guidance in Vietnamese if the query is in Vietnamese.`;

    const response = await this.model.invoke([
      { role: 'system', content: emergencyPrompt },
      { role: 'user', content: query },
    ]);

    return new Command({
      goto: '__end__',
      update: {
        messages: [
          new AIMessage({
            content: response.content as string,
            name: 'emergency_agent',
          }),
        ],
        agentType: 'emergency',
        urgencyLevel: 0.9, // High urgency for emergency agent
      },
    });
  }

  private async clinicalAgent(
    state: typeof MessagesAnnotation.State,
  ): Promise<Command> {
    const query = state.messages[0].content as string;

    const clinicalPrompt = `You are a clinical decision support AI assistant.
    Provide evidence-based medical guidance and symptom analysis.
    
    Query: "${query}"
    
    Focus on:
    - Symptom analysis and differential diagnosis considerations
    - Evidence-based medical guidance
    - When to seek professional medical care
    - Health monitoring recommendations
    
    Always emphasize that this is educational information and not a substitute for professional medical advice.`;

    const response = await this.model.invoke([
      { role: 'system', content: clinicalPrompt },
      { role: 'user', content: query },
    ]);

    return new Command({
      goto: '__end__',
      update: {
        messages: [
          new AIMessage({
            content: response.content as string,
            name: 'clinical_agent',
          }),
        ],
        agentType: 'clinical',
      },
    });
  }

  private async vietnameseMedicalAgent(
    state: typeof MessagesAnnotation.State,
  ): Promise<Command> {
    const query = state.messages[0].content as string;

    const vietnamesePrompt = `You are a Vietnamese healthcare specialist AI assistant.
    Provide culturally appropriate medical guidance integrating traditional and modern medicine.
    
    Query: "${query}"
    
    Focus on:
    - Vietnamese medical terminology and cultural context
    - Traditional medicine (thuốc nam) integration where appropriate
    - Local healthcare practices and preferences
    - Vietnamese healthcare system navigation
    
    Respond in Vietnamese if the query is in Vietnamese, otherwise use English with Vietnamese context.`;

    const response = await this.model.invoke([
      { role: 'system', content: vietnamesePrompt },
      { role: 'user', content: query },
    ]);

    return new Command({
      goto: '__end__',
      update: {
        messages: [
          new AIMessage({
            content: response.content as string,
            name: 'vietnamese_medical_agent',
          }),
        ],
        agentType: 'vietnamese_medical',
      },
    });
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
