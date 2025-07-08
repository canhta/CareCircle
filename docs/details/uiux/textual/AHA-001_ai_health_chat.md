# AI Health Assistant Chat: Text-Based UI Mockup

```
SCREEN: AI Health Assistant Chat
CONTEXT: Main tab in bottom navigation
PURPOSE: Allow users to converse with an AI health assistant for personalized health guidance
```

## Information Architecture

```
DISPLAYS:
- Conversation history between user and AI assistant
- Typing indicator when AI is processing
- Health context panel (collapsible) showing relevant health data being used by AI
- Suggested questions/topics (scrollable horizontal list)
- Message composition area
- Send button
- Voice input button
- Attachment button (for sharing health data, images, etc.)

INPUTS:
- Text input field for user messages
- Voice recording for speech-to-text input
- Attachment selection (health data, images, documents)
- Quick response buttons (Yes/No/Tell me more)
- Feedback buttons on AI responses (helpful/not helpful)

ACTIONS:
- Send text message to AI
- Record and send voice message
- Share health data with AI
- Share images or documents
- Save important responses to health journal
- Share response with care group
- Provide feedback on response quality
- End/restart conversation
```

## User Flow Description

```
ENTRY POINTS:
- Direct navigation from bottom tab bar
- Deep link from notification
- Referral from another feature (e.g., "Ask AI about this" from health data screen)

FLOW:
1. User arrives at chat screen showing conversation history or welcome message
2. User views suggested topics or types custom question
3. User sends message (text or voice)
4. System displays typing indicator while AI processes
5. AI responds with personalized health information
6. User can follow up with additional questions or tap quick response options
7. User can save important information or share with care group

EXIT POINTS:
- Back to previous screen
- To another main tab
- To health data screen (via reference in conversation)
- To medication screen (via reference in conversation)
```

## Functional Requirements

```
REQUIREMENTS:
- Must maintain conversation context across sessions
- Must display health data references used by AI in responses
- Must support both text and voice input methods
- Must allow sharing of responses with care group members
- Must provide feedback mechanism for improving AI responses
- Must cite sources for medical information when appropriate
- Must display appropriate disclaimers for health advice
- Must support both Vietnamese and English languages
- Must handle offline scenarios gracefully

VALIDATIONS:
- Alert for potentially urgent medical questions with appropriate guidance
- Warning when user attempts to use AI for emergency situations
- Confirmation when sharing sensitive health information with care group

STATES:
- Empty state (new conversation)
- Active conversation state
- Offline state with cached responses
- Error state (AI unavailable)
- Typing/processing state
- Language selection state (Vietnamese/English)
```

## Accessibility Considerations

```
ACCESSIBILITY:
- All messages must be properly structured for screen readers
- Voice input must be available for users with mobility limitations
- Visual feedback must be accompanied by haptic/audio feedback
- Text size must be adjustable
- High contrast mode must be supported
- Screen reader announcements for new messages and typing status
- Support for system-level accessibility settings
```

## Reference to Visual Design

```
VISUAL DESIGN:
- See AHA-001_ai_health_chat_visual.md for visual design specifications
```

## Additional Context-Specific Elements

### Health Context Panel

The Health Context Panel is a collapsible section showing what health data the AI is considering:

```
DISPLAYS:
- Recent health metrics (BP, glucose, etc. with timestamps)
- Current medications
- Relevant health conditions
- Data freshness indicators

ACTIONS:
- Expand/collapse panel
- Refresh health data
- Manually add/remove context
```

### Suggested Questions

```
DISPLAYS:
- Contextual question suggestions based on:
  - User health profile
  - Recent health data
  - Conversation history
  - Common follow-ups to previous responses

ACTIONS:
- Tap to select question
- Scroll horizontally to view more
- Dismiss suggestions
```

### Response Cards

For structured information, the AI may respond with specialized cards:

```
CARD TYPES:
- Medication information card
- Health metric trend card
- Lifestyle recommendation card
- Educational content card
- Medical term definition card

CARD ACTIONS:
- Expand for more details
- Save to health journal
- Share with care group
- Set reminder based on card content
```

## Error Handling

```
ERROR SCENARIOS:
- AI service unavailable: Show friendly message with cached responses
- Poor network connection: Optimize for low bandwidth, queue messages
- Inappropriate medical questions: Redirect to appropriate resources
- Language processing errors: Prompt for clarification
- Health data unavailable: Notify user and offer manual input
```

## Privacy Controls

```
PRIVACY FEATURES:
- Clear indicators of what health data is being used
- Option to exclude sensitive data from AI context
- Ability to delete conversation history
- Transparency about data storage and processing
- Consent prompts for new types of health data usage
```
