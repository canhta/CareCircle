# Authentication Flow UI/UX Specification

## Overview

This document provides textual UI/UX mockups for the authentication flows in the CareCircle application, including user registration, sign-in, guest mode, and account linking processes.

## General Design Principles

1. **Simplicity First** - Authentication should be straightforward with minimal friction
2. **Progressive Disclosure** - Only ask for information when needed
3. **Persistent Context** - Maintain state during multi-step processes
4. **Error Prevention** - Provide clear validation and error recovery
5. **Platform Consistency** - Respect platform UI guidelines while maintaining brand identity

## Screen Specifications

### 1. Welcome/Splash Screen

**Screen ID:** AUTH-001

**Description:** Initial screen displayed when app launches for new users

**UI Elements:**

- Logo (centered, top third of screen)
- App name and tagline
- Animation showing app's key features (subtle, unobtrusive)
- "Get Started" primary button
- "Sign In" secondary button
- "Continue as Guest" tertiary link button
- Language selector (small, bottom right)

**Interactions:**

- "Get Started" → Leads to registration options
- "Sign In" → Leads to sign-in screen
- "Continue as Guest" → Triggers anonymous authentication and leads to home screen with limited functionality
- Language selector → Opens language selection modal

**States:**

- Loading state (when checking for existing session)
- Normal state (when no session exists)
- Auto-redirect (when valid session exists)

### 2. Authentication Options Screen

**Screen ID:** AUTH-002

**Description:** Screen presenting all available authentication methods

**UI Elements:**

- "Create Account" header
- Email/Password registration button with email icon
- Phone Number registration button with phone icon
- Google sign-in button with Google logo
- Apple sign-in button with Apple logo (iOS/Web only)
- Facebook sign-in button with Facebook logo
- "Already have an account? Sign In" link at bottom
- "Continue as Guest" tertiary link button
- Back button (top left)

**Interactions:**

- Each auth option button → Leads to corresponding authentication flow
- "Sign In" link → Leads to sign-in screen
- "Continue as Guest" → Triggers anonymous authentication
- Back button → Returns to welcome screen

**States:**

- Normal state
- Loading state (when an authentication method is initiated)
- Error state (with error message when an authentication method fails)

### 3. Email Registration Screen

**Screen ID:** AUTH-003

**Description:** Form for creating a new account with email and password

**UI Elements:**

- "Create Account" header
- Email input field with validation
- Password input field with visibility toggle
- Password strength indicator
- Password requirements helper text
- "Create Account" primary button (initially disabled)
- "Already have an account? Sign In" link at bottom
- Back button (top left)

**Interactions:**

- Email field → Validates format as user types
- Password field → Shows strength and validates requirements as user types
- "Create Account" button → Enabled when both fields are valid, triggers account creation
- "Sign In" link → Leads to sign-in screen
- Back button → Returns to authentication options

**States:**

- Empty state (initial)
- Validation state (showing errors or confirmations)
- Loading state (during account creation)
- Error state (with specific error message)
- Success state (briefly shown before redirection)

### 4. Phone Registration Screen

**Screen ID:** AUTH-004

**Description:** Two-step form for creating an account with phone number verification

**Step 1 UI Elements:**

- "Verify Your Phone" header
- Country code dropdown
- Phone number input field
- "Send Code" primary button (initially disabled)
- Back button (top left)

**Step 2 UI Elements:**

- "Enter Verification Code" header
- 6-digit code input (optimized for numeric entry)
- Countdown timer for code expiration
- "Verify" primary button
- "Didn't receive code? Resend" link (enabled after 30 seconds)
- "Use different number" link
- Back button (top left)

**Interactions:**

- Phone number field → Validates format as user types
- "Send Code" button → Enabled when phone number is valid, sends verification code
- Code input → Auto-advances focus, validates as user types
- "Verify" button → Enabled when code is complete, verifies phone number
- "Resend" link → Resends verification code, resets timer
- "Use different number" → Returns to step 1
- Back button (in step 1) → Returns to authentication options
- Back button (in step 2) → Returns to step 1

**States:**

- Step 1 state (phone number entry)
- Step 2 state (verification code entry)
- Loading states (during code sending and verification)
- Error states (with specific error messages)
- Success state (briefly shown before redirection)

### 5. Sign In Screen

**Screen ID:** AUTH-005

**Description:** Form for existing users to sign in

**UI Elements:**

- "Sign In" header
- Email/Phone input field
- Password input field with visibility toggle
- "Forgot Password?" link
- "Sign In" primary button (initially disabled)
- Social sign-in options (Google, Apple, Facebook) with icons
- "Don't have an account? Create One" link at bottom
- "Continue as Guest" tertiary link button
- Back button (top left)

**Interactions:**

- Email/Phone field → Validates format as user types
- Password field → Validates as user types
- "Sign In" button → Enabled when both fields are valid, triggers authentication
- "Forgot Password?" link → Leads to password reset flow
- Social sign-in buttons → Trigger respective authentication flows
- "Create One" link → Leads to authentication options screen
- "Continue as Guest" → Triggers anonymous authentication
- Back button → Returns to welcome screen or previous screen

**States:**

- Empty state (initial)
- Validation state (showing errors or confirmations)
- Loading state (during authentication)
- Error state (with specific error message)
- Success state (briefly shown before redirection)

### 6. Guest Mode Banner

**Screen ID:** AUTH-006

**Description:** Persistent banner shown to guest users throughout the app

**UI Elements:**

- Slim banner at top of screen
- "You're using CareCircle as a guest" text
- "Create Account" button

**Interactions:**

- "Create Account" button → Opens account creation modal from current screen

**States:**

- Collapsed state (showing minimal information)
- Expanded state (showing benefits of creating an account)
- Hidden state (can be dismissed temporarily)

### 7. Account Creation Modal (from Guest)

**Screen ID:** AUTH-007

**Description:** Modal dialog for converting guest account to permanent account

**UI Elements:**

- "Create Your Account" header
- "Your data will be preserved" subheader with icon
- Authentication options (same as AUTH-002)
- "Not Now" dismissal button
- "Learn More" link with information about data preservation

**Interactions:**

- Authentication option buttons → Lead to respective flows with account linking
- "Not Now" button → Dismisses modal, returns to previous screen
- "Learn More" link → Expands to show detailed information about account linking

**States:**

- Normal state
- Expanded info state (showing more details about account linking)
- Loading state (when an authentication method is initiated)
- Error state (with error message when account linking fails)

### 8. Account Linking Confirmation

**Screen ID:** AUTH-008

**Description:** Screen shown after successful guest-to-permanent account conversion

**UI Elements:**

- Success animation/icon
- "Account Created Successfully" header
- "Your guest data has been transferred" subtext
- Brief summary of transferred data (e.g., "5 health records, 2 care groups")
- "Continue" primary button

**Interactions:**

- "Continue" button → Leads to home screen with full functionality

**States:**

- Success state (default)
- Partial success state (if some data couldn't be transferred)

### 9. Forgot Password Flow

**Screen ID:** AUTH-009

**Description:** Multi-step flow for password reset

**Step 1 UI Elements:**

- "Reset Password" header
- Email input field
- "Send Reset Link" primary button
- Back button (top left)

**Step 2 UI Elements:**

- "Check Your Email" header
- Animation/illustration of email
- Email address text (partially masked)
- "Open Mail App" button (on mobile)
- "Didn't receive email? Resend" link (enabled after 60 seconds)
- "Use different email" link
- Back button (top left)

**Interactions:**

- Email field → Validates format as user types
- "Send Reset Link" button → Enabled when email is valid, sends reset email
- "Open Mail App" button → Opens device's default mail app
- "Resend" link → Resends reset email, resets timer
- "Use different email" → Returns to step 1
- Back button (in step 1) → Returns to sign-in screen
- Back button (in step 2) → Returns to step 1

**States:**

- Step 1 state (email entry)
- Step 2 state (waiting for email action)
- Loading states (during email sending)
- Error states (with specific error messages)

### 10. Account Conflict Resolution

**Screen ID:** AUTH-010

**Description:** Screen shown when trying to link a guest account to an existing account

**UI Elements:**

- "Account Already Exists" header
- Explanation text about the conflict
- "Transfer Guest Data" option with explanation
- "Keep Existing Data" option with explanation
- "Cancel" link
- Back button (top left)

**Interactions:**

- "Transfer Guest Data" button → Initiates data migration from guest to existing account
- "Keep Existing Data" button → Discards guest data, continues with existing account
- "Cancel" link → Cancels the operation, returns to previous screen
- Back button → Returns to previous screen

**States:**

- Normal state (options presentation)
- Loading state (during conflict resolution)
- Error state (if conflict resolution fails)
- Success state (after successful resolution)

## User Flows

### 1. New User Registration Flow

```
Welcome Screen (AUTH-001)
        ↓
Authentication Options (AUTH-002)
        ↓
    ┌───┴───┐
    ↓       ↓
Email Registration    Phone Registration
(AUTH-003)           (AUTH-004)
    ↓       ↓
    └───┬───┘
        ↓
Home Screen (with onboarding)
```

### 2. Existing User Sign-In Flow

```
Welcome Screen (AUTH-001)
        ↓
    Sign In Screen (AUTH-005)
        ↓
    ┌───┴────────┐
    ↓            ↓
Regular Sign-In   Forgot Password Flow
                  (AUTH-009)
    ↓            ↓
    └───┬────────┘
        ↓
    Home Screen
```

### 3. Guest Mode Flow

```
Welcome Screen (AUTH-001)
        ↓
"Continue as Guest"
        ↓
Home Screen (with guest banner AUTH-006)
        ↓
Guest Banner "Create Account" clicked
        ↓
Account Creation Modal (AUTH-007)
        ↓
Authentication Flow with Account Linking
        ↓
Account Linking Confirmation (AUTH-008)
        ↓
Home Screen (full functionality)
```

### 4. Account Conflict Resolution Flow

```
Guest Account Linking Attempt
        ↓
Account Conflict Detection
        ↓
Account Conflict Resolution Screen (AUTH-010)
        ↓
    ┌───┴───┐
    ↓       ↓
Transfer Data    Keep Existing Data
    ↓       ↓
    └───┬───┘
        ↓
Account Linking Confirmation (AUTH-008)
        ↓
Home Screen (full functionality)
```

## Accessibility Considerations

1. **Screen Readers**

   - All screens must have proper accessibility labels
   - Focus order should follow logical progression
   - Error messages must be announced when they appear

2. **Visual Accessibility**

   - Maintain minimum contrast ratio of 4.5:1 for all text
   - Support dynamic text sizing
   - Provide visual cues beyond color for state changes

3. **Motor Control**

   - Touch targets minimum size of 44x44 points
   - Adequate spacing between interactive elements
   - Support for platform accessibility features like AssistiveTouch or Voice Control

4. **Cognitive Accessibility**
   - Clear, concise language
   - Consistent UI patterns throughout
   - Visual reinforcement of actions
   - Forgiving input validation with clear error messages

## Error Handling

1. **Input Validation Errors**

   - Show inline validation errors as user types
   - Provide specific guidance on how to fix the error
   - Allow easy correction without clearing entire fields

2. **Authentication Errors**

   - Distinguish between user errors (wrong password) and system errors
   - Provide clear next steps for recovery
   - Secure error messages that don't leak account existence

3. **Network Errors**

   - Clear indication of offline status
   - Ability to retry operations when connection restored
   - Graceful degradation of functionality in offline mode

4. **Account Conflicts**
   - Clear explanation of the conflict
   - Simple options for resolution
   - Data preservation guarantees

## Platform-Specific Adaptations

### iOS

- Use native iOS form elements and conventions
- Implement Apple Sign-In prominently
- Support password autofill from iCloud Keychain
- Utilize Touch ID/Face ID for reauthentication

### Android

- Follow Material Design guidelines
- Support Android's autofill framework
- Implement biometric authentication via Biometric API
- Utilize Google Smart Lock where appropriate

### Web

- Responsive design adapting to desktop and mobile viewports
- Support browser autocomplete attributes
- Implement WebAuthn for supported browsers
- Consider progressive web app capabilities for offline support

## Microcopy Guidelines

1. **Button Labels**

   - Use action verbs ("Create Account" not "Submit")
   - Be concise but clear
   - Avoid technical jargon

2. **Error Messages**

   - Be specific about what went wrong
   - Suggest a solution when possible
   - Use friendly, non-blaming language

3. **Help Text**

   - Provide context just when needed
   - Use tooltips for advanced concepts
   - Keep explanations brief and scannable

4. **Confirmations**
   - Clearly state what happened
   - Confirm user identity when appropriate
   - Indicate next steps when relevant
