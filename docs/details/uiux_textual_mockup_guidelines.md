# UI/UX Text-Based Mockup Guidelines

## Overview

This document outlines the approach for creating text-based UI/UX mockups for the CareCircle platform. These mockups focus on describing functionality and user interactions textually, while visual design elements are documented separately. This separation allows for clear communication of functional requirements without being constrained by visual design decisions that may evolve independently.

## Purpose

1. **Functional Clarity**: Describe what a screen does rather than exactly how it looks
2. **Interaction Focus**: Emphasize user interactions and information architecture
3. **Separation of Concerns**: Decouple functional requirements from visual design decisions
4. **Accessibility First**: Ensure core functionality is understood independent of visual presentation

## Text-Based Mockup Structure

Each text-based UI mockup should follow this structure:

### 1. Screen Identification

```
SCREEN: [Screen Name]
CONTEXT: [Where in the app flow this appears]
PURPOSE: [Primary user goal for this screen]
```

### 2. Information Architecture

```
DISPLAYS:
- [Key information element 1]
- [Key information element 2]
- ...

INPUTS:
- [User input element 1]
- [User input element 2]
- ...

ACTIONS:
- [Primary action]
- [Secondary action]
- [Tertiary actions]
- ...
```

### 3. User Flow Description

```
ENTRY POINTS:
- [How users arrive at this screen]

FLOW:
1. [First step in typical user interaction]
2. [Second step]
3. ...

EXIT POINTS:
- [Where users go after completing actions]
```

### 4. Functional Requirements

```
REQUIREMENTS:
- [Functional requirement 1]
- [Functional requirement 2]
- ...

VALIDATIONS:
- [Input validation 1]
- [Input validation 2]
- ...

STATES:
- [Different states the screen can be in]
```

### 5. Accessibility Considerations

```
ACCESSIBILITY:
- [Screen reader considerations]
- [Keyboard navigation patterns]
- [Other accessibility requirements]
```

### 6. Reference to Visual Design

```
VISUAL DESIGN:
- See [link to visual design document]
```

## Example: Medication Reminder Screen

```
SCREEN: Medication Reminder
CONTEXT: Home tab > Medication section
PURPOSE: Allow users to view upcoming medication doses and mark them as taken

DISPLAYS:
- Current date and time
- List of medications due today (grouped by time)
- Medication details (name, dosage, instructions)
- Medication status indicators (taken, missed, upcoming)
- Time until next dose

INPUTS:
- Checkbox for marking medication as taken
- Optional notes field for each medication

ACTIONS:
- Mark medication as taken
- Snooze reminder
- View detailed medication information
- Report side effects

ENTRY POINTS:
- Home screen medication widget
- Notification tap
- Manual navigation from medication tab

FLOW:
1. User views list of medications due
2. User marks medication as taken or snoozes
3. System records action and updates status
4. Confirmation feedback is provided

EXIT POINTS:
- Back to home screen
- To detailed medication view
- To medication history

REQUIREMENTS:
- Must display medications chronologically by due time
- Must show visual differentiation between taken, missed, and upcoming doses
- Must allow batch actions for multiple medications due at same time
- Must sync status changes with care group members

VALIDATIONS:
- Prevent marking future medications as taken
- Confirm when marking medication as taken outside expected time window

STATES:
- Normal view (upcoming medications)
- Empty state (no medications due)
- Error state (sync issues)
- Offline state

ACCESSIBILITY:
- Each medication must be navigable with screen reader
- Status changes must be announced
- Color is not the only indicator of medication status

VISUAL DESIGN:
- See Medication Reminder Screen in UI Style Guide
```

## Benefits of Text-Based Mockups

1. **Focus on User Needs**: Emphasizes what users need to accomplish
2. **Platform Agnostic**: Functional requirements apply across platforms and screen sizes
3. **Collaboration Friendly**: Easier for non-designers to review and contribute to
4. **Stable Reference**: Less volatile than visual designs that may change frequently
5. **Accessibility Built-In**: Forces consideration of non-visual interactions

## Connection to Visual Design Documents

Each text-based mockup should reference the corresponding visual design document, which contains:

1. **Wireframes/Mockups**: Visual representation of screens
2. **Style Guide Application**: How brand styles apply to this screen
3. **Component Usage**: Which design system components are used
4. **Responsive Behavior**: How the screen adapts to different devices
5. **Visual States**: How different states appear visually

## Implementation Process

1. Create text-based mockups during feature specification
2. Reference these mockups in feature documents
3. Develop visual designs in parallel, informed by text-based requirements
4. Cross-reference between functional and visual documentation
5. Use both documents during development and testing

## Location and Naming Convention

Text-based mockups should be stored in:

- `./docs/details/uiux/textual/[feature_id]_[screen_name].md`

Visual design references should be stored in:

- `./docs/details/uiux/visual/[feature_id]_[screen_name].md`

## Sample Screens for Initial Implementation

1. Medication Reminder Screen
2. Health Data Input Screen
3. Care Group Dashboard
4. AI Health Assistant Chat
5. Emergency Contact Screen
