# CareCircle UI/UX Documentation

This directory contains user interface and user experience specifications for the CareCircle platform. The documentation is structured to separate textual functional requirements from visual design specifications.

## Documentation Structure

The UI/UX documentation follows a separation of concerns approach:

1. **[Textual Mockups](./textual/)**: Functional descriptions focusing on:

   - Information architecture
   - User flows
   - Screen content and states
   - Functional requirements
   - Accessibility considerations

2. **[Visual Design Documents](./visual/)**: Visual specifications focusing on:
   - Visual composition and layout
   - Style guide application
   - Component usage
   - Responsive design
   - Animation and transitions

## Relationship with Other Documentation

The UI/UX specifications work together with:

1. **Feature Specifications** (`../feature_*.md`) - Define the overall feature requirements
2. **Module Documentation** (`../../modules/`) - Provide technical implementation details

## Using These Documents

When implementing UI/UX components:

1. Start with the textual mockups to understand functional requirements
2. Reference the visual design documents for styling guidance
3. Refer to the module documentation for the underlying implementation details
4. Use the feature specifications to understand the feature context

## Document Pairs

For each feature, there is typically a pair of documents:

| Feature             | Textual Mockup                                                             | Visual Design                                                                           |
| ------------------- | -------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- |
| AI Health Chat      | [AHA-001_ai_health_chat.md](./textual/AHA-001_ai_health_chat.md)           | [AHA-001_ai_health_chat_visual.md](./visual/AHA-001_ai_health_chat_visual.md)           |
| Medication Reminder | [MM-002_medication_reminder.md](./textual/MM-002_medication_reminder.md)   | [MM-002_medication_reminder_visual.md](./visual/MM-002_medication_reminder_visual.md)   |
| Authentication Flow | [UM-010_authentication_flow.md](./textual/UM-010_authentication_flow.md)   | [UM-010_authentication_flow_visual.md](./visual/UM-010_authentication_flow_visual.md)   |
| Notification System | [NSS-001_notification_system.md](./textual/NSS-001_notification_system.md) | [NSS-001_notification_system_visual.md](./visual/NSS-001_notification_system_visual.md) |

## Guidance for Creating New UI/UX Documentation

When adding new UI/UX documentation:

1. Create the textual mockup first to define functionality
2. Follow with the visual design document once the functionality is approved
3. Link both documents from relevant feature specifications and module documentation
4. Update this README with the new document pairs
