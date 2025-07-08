# Medication Reminder: Text-Based UI Mockup

```
SCREEN: Medication Reminder
CONTEXT: Home tab > Medication section or direct access from notification
PURPOSE: Allow users to view and manage upcoming medication doses
```

## Information Architecture

```
DISPLAYS:
- Current date and time
- Medication timeline organized by time slots
- Medication cards with:
  - Medication name and image
  - Dosage information
  - Administration instructions
  - Status indicator (taken, missed, upcoming)
  - Time due or time since due
- Adherence summary for the day
- Quick action buttons
- Medication-specific notes (if any)

INPUTS:
- Checkbox/swipe to mark medication as taken
- Time selection for "taken at different time"
- Optional notes field
- Skip dose reason selection (if skipping)

ACTIONS:
- Mark medication as taken
- Mark medication as skipped
- Add notes to medication dose
- Snooze reminder
- View detailed medication information
- Report side effects
- Adjust medication schedule (with appropriate permissions)
- Share adherence with care group
```

## User Flow Description

```
ENTRY POINTS:
- Home screen medication widget
- Reminder notification
- Medication tab
- Care group shared alert

FLOW:
1. User views timeline of medications due today
2. User selects a medication to view details
3. User marks medication as taken, skipped, or snoozes
4. System provides confirmation feedback
5. System updates medication status and adherence metrics
6. System notifies care group members (if configured)

EXIT POINTS:
- Back to home screen
- To detailed medication information screen
- To medication history/adherence screen
- To side effect reporting screen
```

## Functional Requirements

```
REQUIREMENTS:
- Must display medications chronologically
- Must visually distinguish between taken, missed, and upcoming doses
- Must allow marking medications as taken within configurable time window
- Must support batch actions for medications due at the same time
- Must sync status changes with care group in near real-time
- Must work offline with synchronization when back online
- Must support custom reminder sounds and notification styles
- Must display relevant medication warnings and instructions
- Must track adherence metrics for reporting

VALIDATIONS:
- Prevent marking future medications as taken
- Request confirmation when marking medication as taken outside expected time window
- Require reason selection when skipping a dose
- Alert when marking potentially dangerous medication combinations as taken

STATES:
- Normal view (medications grouped by time)
- Empty state (no medications due)
- Filtered view (specific medication type)
- Timeline view (chronological)
- Grid view (by medication)
- Offline state
- Error state (sync issues)
- Care recipient view (when managing another person's medications)
```

## Accessibility Considerations

```
ACCESSIBILITY:
- Screen reader optimization for medication names and status
- Non-color indicators for medication status (patterns, icons)
- Voice commands for marking medications
- Haptic feedback for confirmation
- Large touch targets for elderly users
- Clear, high-contrast text for medication names and instructions
- Support for system text size settings
```

## Reference to Visual Design

```
VISUAL DESIGN:
- See MM-002_medication_reminder_visual.md for visual design specifications
```

## Additional Context-Specific Elements

### Timeline Navigation

```
DISPLAYS:
- Current day in focus
- Previous and next day navigation
- Week view toggle
- Jump to date selector

ACTIONS:
- Swipe between days
- Tap to select specific date
- Toggle between day/week views
```

### Medication Groups

Medications are grouped in relevant ways to improve usability:

```
GROUPING OPTIONS:
- By time (default): Morning, Afternoon, Evening, Bedtime
- By type: Prescription, OTC, Supplements
- By condition: Diabetes, Hypertension, etc.
- By person: When managing multiple family members

ACTIONS:
- Switch between grouping options
- Expand/collapse groups
- Take all medications in a group
```

### Adherence Summary

```
DISPLAYS:
- Today's adherence percentage
- Weekly trend indicator
- Streak counter (consecutive days of perfect adherence)
- Visual calendar of adherence history

ACTIONS:
- Tap to view detailed adherence analytics
- Share adherence report with healthcare provider
- Set adherence goals
```

### Medication Interactions

```
DISPLAYS:
- Warning indicators for potential interactions
- Food interaction reminders
- Timing optimization suggestions

ACTIONS:
- View detailed interaction information
- Acknowledge warnings
- Adjust schedule to optimize effectiveness
```

## Error Handling

```
ERROR SCENARIOS:
- Sync failure: Show last synced timestamp, queue changes
- Medication data unavailable: Show placeholder with refresh option
- Reminder failure: Provide manual reminder check option
- Permission issues: Clear explanation of required permissions
```

## Personalization Options

```
CUSTOMIZATION FEATURES:
- Preferred time format (12h/24h)
- Default view (timeline/grid)
- Reminder intensity settings
- Color coding options for medication types
- Custom medication icons or photos
- Preferred grouping method
```

## Care Group Integration

```
CARE GROUP FEATURES:
- Visibility indicators showing which care group members can see this information
- Adherence alerts configuration for caregivers
- Caregiver assistance request button
- Adherence verification by caregiver
- Medication supervision mode for dependents
```
