# Notification System UI/UX Specification

## Overview

This document provides textual UI/UX mockups for the AI-powered smart notification system in the CareCircle application, including notification settings, notification center, and notification display across different contexts.

## General Design Principles

1. **Minimal Intrusion** - Notifications should be helpful without being annoying
2. **Contextual Relevance** - Content and timing should match user context
3. **Clear Actions** - Each notification should have obvious actions to take
4. **Consistent Branding** - Visual style consistent with app design language
5. **Cultural Sensitivity** - Adapt content and timing for Southeast Asian users

## Screen Specifications

### 1. Notification Settings Screen

**Screen ID:** NSS-101

**Description:** Screen for managing notification preferences

**UI Elements:**

- "Notification Settings" header
- Master toggle for all notifications (on/off)
- Category sections with expandable details:
  - Health Reminders
  - Medication Alerts
  - Care Group Updates
  - Account Notifications
  - Educational Content
- For each category:
  - Toggle switch (on/off)
  - Time window selector ("Only from 8 AM to 10 PM")
  - Frequency selector (Low/Medium/High)
  - Priority selector (Normal/High)
- "Quiet Hours" section with time range selectors
- "Save Preferences" primary button
- "Reset to Default" secondary button
- Back button (top left)

**Interactions:**

- Master toggle → Enables/disables all notifications
- Category toggles → Enable/disable specific categories
- Time window selector → Opens time picker dialog
- Frequency selector → Opens dropdown with options
- "Save Preferences" → Saves settings and returns to previous screen
- "Reset to Default" → Confirms via dialog, then resets all settings
- Back button → Returns to previous screen, prompts to save changes if needed

**States:**

- Default state (showing current settings)
- Loading state (when fetching or saving preferences)
- Error state (if settings can't be saved)
- Disabled state (if notifications are disabled at system level)

### 2. Notification Center Screen

**Screen ID:** NSS-102

**Description:** Central hub for viewing all past notifications

**UI Elements:**

- "Notifications" header
- Filter tabs: "All" / "Unread" / "Important"
- Search field (with notification content search capability)
- Chronological grouping headers ("Today", "Yesterday", "This Week", "Earlier")
- Notification list items, each containing:
  - Icon representing notification type
  - Title
  - Preview text
  - Timestamp
  - Action button (if applicable)
  - Unread indicator (if applicable)
- "Clear All" button (bottom)
- "Mark All as Read" button (when unread notifications exist)
- Empty state illustration and text (when no notifications)
- Back button (top left)

**Interactions:**

- Filter tabs → Filter displayed notifications
- Search field → Filters notifications by content
- Notification item tap → Expands notification with full content and actions
- Notification item swipe → Reveals delete/mark as read actions
- "Clear All" button → Confirms via dialog, then clears all notifications
- "Mark All as Read" → Marks all notifications as read
- Back button → Returns to previous screen

**States:**

- Loaded state (showing notifications)
- Empty state (no notifications)
- Loading state (when fetching notifications)
- Search state (when searching)
- Error state (if notifications can't be loaded)

### 3. Push Notification Display

**Screen ID:** NSS-103

**Description:** System-level push notification appearance

**UI Elements:**

- Icon (CareCircle app icon)
- App name ("CareCircle")
- Notification title (bold)
- Notification body text
- Timestamp
- Action buttons (0-2 contextual actions)
- Expandable view (for longer notifications)

**Variations:**

- **Standard Notification:**

  - Title, body text, timestamp
  - Default action: open relevant app screen

- **Actionable Notification:**

  - Title, body text, timestamp
  - Primary action button (e.g., "Take Medication")
  - Secondary action button (e.g., "Snooze")

- **Rich Notification (iOS/Android support):**
  - Title, body text, timestamp
  - Media attachment (image)
  - Multiple action buttons

**States:**

- Collapsed state (standard view)
- Expanded state (showing full content and actions)
- Interacted state (user is taking action)

### 4. In-App Notification Banner

**Screen ID:** NSS-104

**Description:** Temporary banner shown within the app for important notifications

**UI Elements:**

- Slim banner at top of screen
- Icon representing notification type
- Short notification text
- Single action button or link (optional)
- Dismiss button (X)

**Interactions:**

- Banner tap → Opens full notification detail
- Action button tap → Performs specific action
- Dismiss button → Dismisses the banner
- Auto-dismiss → Banner disappears after 5 seconds if no interaction

**States:**

- Appearing state (slides in from top)
- Visible state (stable display)
- Dismissing state (slides out or fades)

### 5. Notification Detail Modal

**Screen ID:** NSS-105

**Description:** Modal showing full notification details and actions

**UI Elements:**

- Modal container (slides up from bottom)
- Notification title
- Full notification text
- Timestamp
- Related content (if applicable)
- Primary action button
- Secondary action button(s)
- "Don't show again" option (for specific notification types)
- Dismiss handle (top center) or close button (top right)

**Interactions:**

- Primary action button → Performs main action and closes modal
- Secondary action button → Performs alternative action
- "Don't show again" → Updates notification preferences
- Dismiss handle/close button → Closes modal
- Background tap → Closes modal

**States:**

- Opening state (sliding up)
- Open state (fully visible)
- Closing state (sliding down)
- Action loading state (when action is processing)

## User Flows

### 1. Receiving and Acting on a Notification

```
System Push Notification Received
        ↓
    User taps notification
        ↓
App opens to relevant screen
        ↓
    ┌───┴───┐
    ↓       ↓
Take Action   Dismiss
    ↓       ↓
Confirmation   Return to
Feedback      Previous Activity
```

### 2. Managing Notification Settings

```
App Settings
    ↓
Notification Settings (NSS-101)
    ↓
    ┌─────┬─────┬─────┐
    ↓     ↓     ↓     ↓
Adjust   Adjust  Set   Toggle
Categories Timing Quiet Hours Master Switch
    ↓     ↓     ↓     ↓
    └─────┴─────┴─────┘
            ↓
    Save Preferences
            ↓
Settings Applied Confirmation
```

### 3. Using the Notification Center

```
Home Screen
    ↓
Notification Center (NSS-102)
    ↓
    ┌───┬───┬───┐
    ↓   ↓   ↓   ↓
View  Filter Search Take Action
Item         on Item
    ↓   ↓   ↓   ↓
    └───┴───┴───┘
        ↓
Return to Previous Screen
```

## Notification Types and Variations

### 1. Medication Reminder

**Standard:**

- Title: "Time for [Medication Name]"
- Body: "It's time to take your [dosage] [medication name]."
- Actions: "Take Now" | "Snooze 15 Min"

**Missed:**

- Title: "Missed [Medication Name]"
- Body: "You haven't marked your [medication name] as taken. Did you take it?"
- Actions: "Taken" | "Skip" | "Remind Later"

**Persistent:**

- Title: "Important Medication Due"
- Body: "Your [medication name] is overdue by [time]. Please take it now."
- Actions: "Take Now" | "Taken Already" | "Skip"

### 2. Health Check Reminder

**Routine:**

- Title: "Time for [Health Check]"
- Body: "It's time for your [daily/weekly] [health check type]."
- Actions: "Record Now" | "Remind Later"

**Streaks-Based:**

- Title: "Keep Your Streak Going!"
- Body: "You've recorded your [health check] for [X] days. Don't break your streak!"
- Actions: "Record Now" | "Remind Later"

**Re-engagement:**

- Title: "Resume Your Health Tracking"
- Body: "It's been [X] days since your last [health check]. Let's get back on track!"
- Actions: "Record Now" | "Set New Schedule"

### 3. Care Group Updates

**Activity:**

- Title: "[Member Name] updated [health record]"
- Body: "[Member name] has added new information about [health record type]."
- Actions: "View Update" | "Dismiss"

**Request:**

- Title: "Action needed for [Member Name]"
- Body: "[Member name] needs assistance with [task/medication/appointment]."
- Actions: "Respond" | "View Details" | "Not Now"

**Milestone:**

- Title: "Milestone Reached!"
- Body: "[Member name] has completed [achievement]. Send them encouragement!"
- Actions: "Send Message" | "View Details"

### 4. Guest Conversion

**Data Protection:**

- Title: "Protect Your Health Data"
- Body: "You've added [X] health records. Create an account to ensure they're saved securely."
- Actions: "Create Account" | "Learn More"

**Feature Unlock:**

- Title: "Unlock More Features"
- Body: "Create an account to share health information with family members and caregivers."
- Actions: "Create Account" | "Not Now"

**Progress Preservation:**

- Title: "Don't Lose Your Progress"
- Body: "You've been using CareCircle for [X] days. Create an account to ensure your data is saved."
- Actions: "Create Account" | "Remind Later"

## Accessibility Considerations

1. **Screen Readers**

   - All notification elements must have proper accessibility labels
   - Notifications should include TalkBack/VoiceOver hints for available actions
   - Critical notifications should interrupt screen readers when appropriate

2. **Visual Accessibility**

   - High contrast between notification elements and backgrounds
   - Support for system font size adjustments
   - Sufficient color contrast (minimum 4.5:1 ratio)
   - Visual indicators beyond color alone

3. **Motor Control**
   - Touch targets for notification actions minimum 44x44 points
   - Sufficient spacing between action buttons
   - Easy dismissal mechanisms
   - Extended timeouts for action-required notifications

## Cultural Adaptations for Southeast Asia

1. **Language Considerations**

   - Support for Vietnamese, Thai, Bahasa Indonesia, Tagalog, and other regional languages
   - Proper formatting for names and honorifics

2. **Timing Adaptations**

   - Respect for prayer times in Muslim-majority regions
   - Awareness of local holidays and observances
   - Consideration of regional daily routines and meal times

3. **Content Adaptations**
   - Use of culturally relevant metaphors and examples
   - Appropriate levels of directness/indirectness based on cultural norms
   - Family-oriented messaging to reflect regional values

## Error States and Recovery

1. **Delivery Failures**

   - Retry logic for failed notifications
   - In-app fallback for system notification failures
   - Synchronization of notification status across devices

2. **Action Failures**

   - Clear error messaging when notification actions fail
   - Graceful degradation for offline actions
   - Alternate action paths when primary action is unavailable

3. **Preference Conflicts**
   - Resolution strategy for conflicting notification settings
   - User notification when system settings override app preferences
   - Guidance for optimal notification setup

## Platform-Specific Adaptations

### iOS

- Support for notification grouping
- Implementation of rich notifications with media attachments
- Use of notification extensions for additional functionality
- Support for critical alerts (for medication reminders)

### Android

- Support for notification channels
- Implementation of notification importance levels
- Use of big picture and big text styles
- Support for direct reply in notifications

### Web

- Implementation of progressive web app notifications
- Fallback strategies for browsers without notification support
- Use of service workers for offline notification delivery

## Implementation Guidelines

1. **Performance Considerations**

   - Minimize battery impact of notification processing
   - Optimize notification payload size
   - Implement efficient background processing

2. **Security Considerations**

   - Encryption of sensitive health data in notifications
   - Prevention of notification content leakage on secure devices
   - Authentication for sensitive notification actions

3. **Testing Requirements**
   - Cross-device notification appearance testing
   - Background/foreground delivery testing
   - Action handling in various connectivity states
   - Cultural appropriateness validation
