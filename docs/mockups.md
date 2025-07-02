# Text-Based Screen Mockups for CareCircle

This document provides a detailed description of the screens for the CareCircle mobile application and the administrative web portal, as derived from the Business Requirements Document (BRD).

**Note on Localization (NFR-5.1)**: All user-facing text in the mobile app and web portal must be available in both **English** and **Vietnamese**. A language selector should be available in the initial setup and settings.

---

## Part 1: Mobile App Screen Mockups

### **Section 1: Onboarding & Authentication**

**Screen 1.1: Splash Screen**
*   **Actor**: Any User
*   **Display Elements**:
    *   CareCircle Logo
    *   App Tagline: "Your Family-First AI Health Agent."
*   **Function**: Displays while the app loads initially.
*   **Screen Flow**: Automatically transitions to the Onboarding Carousel or Login/Register screen.

**Screen 1.2: Onboarding Carousel**
*   **Actor**: New User
*   **Display Elements**:
    *   A series of 3-4 swipeable cards highlighting key benefits (USP):
        1.  "**Stay on Track, Together**": Shows a graphic of a family connected around a health icon. (Covers Family Coordination)
        2.  "**Smart Reminders, Just for You**": Illustrates the adaptive notification concept. (Covers Behavioral AI)
        3.  "**Scan Prescriptions Instantly**": Shows a phone scanning a prescription. (Covers OCR)
        4.  "**Your Health, Your Rules**": Highlights privacy and control. (Covers Privacy)
    *   "Skip" button
    *   "Get Started" button
*   **Function**: Educates the user on the app's value proposition.
*   **Screen Flow**:
    *   On "Get Started" -> Navigates to Login/Register Screen (1.3).
    *   On "Skip" -> Navigates to Login/Register Screen (1.3).

**Screen 1.3: Login / Register Screen**
*   **Actor**: New or Returning User
*   **Display Elements**:
    *   App Logo
    *   Tabs: "Login" | "Register"
    *   **Register Tab (Default)**:
        *   Email input field
        *   Password input field (with show/hide toggle)
        *   "Register" button
        *   Social SSO Buttons (FR-1.1):
            *   [G] Continue with Google
            *   [] Continue with Apple
        *   Text: "By registering, you agree to our Terms of Service and Privacy Policy." (links included)
    *   **Login Tab**:
        *   Email input field
        *   Password input field
        *   "Forgot Password?" link
        *   "Login" button
        *   Social SSO Buttons
*   **Function**: Allows users to create an account or sign in (FR-1.1, FR-1.2).
*   **Screen Flow**:
    *   On successful registration/login -> Navigates to Initial Setup (1.4).
    *   "Forgot Password?" -> Navigates to a password reset flow (not detailed).

**Screen 1.4: Guided Setup with AI Assist**
*   **Actor**: New User
*   **Concept**: A multi-step onboarding process that combines traditional forms with optional AI assistance, providing structure while still feeling intelligent and reducing manual entry.
*   **Display Elements**:
    *   **Step 1: Add Your First Medication**
        *   Title: "Let's set up your medications."
        *   **AI Suggestion Box**: A text field at the top with a prompt: "You can type something like 'Metformin 500mg once a day after breakfast' and I'll fill out the form for you."
        *   **Manual Form**: Standard input fields for "Medication Name", "Dosage", "Frequency", and "Time". These fields can be auto-populated by the AI parser.
        *   Buttons: `[Scan Prescription]` `[Add Manually]`
        *   A "Skip for now" link.
    *   **Step 2: Connect Health Data**
        *   Title: "Connect Your Health Data"
        *   Explanation: "Get deeper insights by connecting to Apple Health / Google Fit."
        *   Button: `[] Connect to Apple Health` or `[G] Connect to Google Fit`.
    *   **Step 3: Personalize Notifications**
        *   Title: "How would you like to be reminded?"
        *   Options for notification tone (e.g., Gentle, Direct) and snooze duration.
    *   "Finish Setup" button.
*   **Function**: Guides the user through the most critical setup steps (medication, data consent, notifications) in a structured way. The AI is available to speed up the process without completely replacing the familiar form-based interface (FR-1.4, FR-3.1).
*   **Screen Flow**:
    *   On "Finish Setup" -> Navigates to Home Dashboard (2.1).

---

### **Section 2: Core Application Screens**

**Screen 2.1: Home Dashboard**
*   **Actor**: Patient, General Wellness User, Caregiver
*   **Display Elements (Widget-based, customizable as per FR-10.2)**:
    *   **Header**:
        *   Greeting: "Hello, [User Name]"
        *   Profile/Settings Icon
    *   **Main Vitals Widget**: A large card displaying the most relevant health metric (e.g., Blood Pressure, Glucose).
    *   **AI Insights Widget (New)**:
        *   A collapsible card with an AI icon.
        *   **One-Line Summary**: Surfaces a proactive, actionable insight (FR-7.2). Examples:
            *   "Your average morning blood pressure is trending up. Consider talking to your doctor."
            *   "You missed one dose yesterday. Tap here to see how to catch up safely."
        *   **"Learn More" Button**: Expands the card to show more details or historical data.
    *   **Today's Medications Widget**: A checklist of medications for the day.
    *   **Care Group Status Widget**: A summary of connected family members' status.
    *   **Floating Action Button (+)**: Main action button.
*   **Function**: Provides an at-a-glance overview of the user's health status and daily tasks.
*   **Screen Flow**:
    *   Tapping Profile/Settings Icon -> Navigates to Settings Screen (3.1).
    *   Tapping Check-in buttons -> Logs state, may navigate to a more detailed check-in screen (FR-5.3).
    *   Tapping a medication -> Opens medication details.
    *   Tapping a vital -> Navigates to Health Metrics Dashboard (2.4).
    *   Tapping Floating Action Button -> Opens a menu: "Add Medication", "Log Vitals Manually", "Export Summary".

**Screen 2.2: Medication Management**
*   **Actor**: Patient, Caregiver
*   **Display Elements**:
    *   Header: "My Medications"
    *   List of all medications. Each item shows:
        *   Drug Name ("Metformin")
        *   Dosage ("500mg")
        *   Schedule ("Twice a day")
    *   Button: "Add Medication"
*   **Function**: View and manage the list of medications (FR-3.4).
*   **Screen Flow**:
    *   Tapping "Add Medication" -> Opens a choice: "Scan Prescription" or "Enter Manually".
        *   "Scan Prescription" -> Opens OCR Scanner (2.3).
        *   "Enter Manually" -> Opens a form to add medication details.
    *   Tapping a medication -> Opens a detail view with an "Edit" button and an option to view an **AI-Powered Summary (FR-7.1, Premium Feature)**.

**Screen 2.3: OCR Prescription Scanner (AI-Enhanced)**
*   **Actor**: Patient, Caregiver
*   **Display Elements**:
    *   Camera view with an overlay guiding the user to frame the prescription.
    *   "Scan" button.
    *   **Post-Scan View**:
        *   The app displays the extracted medication name, dosage, and frequency.
        *   **AI-Powered "Recommended Schedule" Section**:
            *   A pre-filled schedule suggested by the AI (e.g., "8:00 AM & 8:00 PM").
            *   The AI's reasoning is briefly stated: "Based on typical dosing for this medication."
            *   The user can easily edit the suggested times.
*   **Function**: To scan, automatically populate medication details (FR-3.1), and suggest an optimal schedule to reduce user effort.
*   **Screen Flow**:
    *   After user confirms the schedule -> Adds the medication and returns to Medication Management screen (2.2).

**Screen 2.4: Health Metrics Dashboard**
*   **Actor**: Patient, Caregiver, Wellness User
*   **Display Elements**:
    *   Header: "Health Trends"
    *   Tabs for different metrics: "Activity", "Sleep", "Mood", "Vitals".
    *   Each tab contains graphs visualizing data over time (Day/Week/Month views).
    *   AI Insight Snippet (FR-7.2): A text box with a summary, e.g., "We noticed your average sleep quality improved by 15% this week. Keep it up!"
*   **Function**: Allows users to view and analyze their health data trends (FR-2.4).
*   **Screen Flow**: Navigates from the Home Dashboard.

**Screen 2.5: Care Groups**
*   **Actor**: Patient, Caregiver
*   **Display Elements**:
    *   Header: "My Care Groups"
    *   List of Care Groups the user is in. Each item shows the group name and member avatars.
    *   Button: "Create New Group"
*   **Function**: Manage and access Care Groups (FR-6.1).
*   **Screen Flow**:
    *   Tapping a group -> Navigates to Care Group Details (2.6).
    *   Tapping "Create New Group" -> Starts the group creation flow.

**Screen 2.6: Care Group Details**
*   **Actor**: Patient, Caregiver
*   **Display Elements**:
    *   Header: [Group Name]
    *   **AI Alert Badge (New)**: A small AI icon appears next to a member's name if the system detects a concerning pattern (e.g., multiple missed check-ins, consistently high blood sugar readings).
    *   Member List: Shows all members in the group.
    *   Shared Data View: A dashboard showing the health data the patient has chosen to share.
    *   "Invite Member" button.
*   **Function**: View shared data, manage members, and control data sharing permissions. The AI alert prompts caregivers to check in when potential issues arise.
*   **Screen Flow**:
    *   "Invite Member" -> Generates a shareable link (FR-6.2).
    *   Tapping the AI Alert Badge -> Opens a dialog with a pre-written message suggestion, e.g., "I noticed your blood sugar has been high a few times this week. Everything okay? You can send this message with one tap."

**Screen 2.7: Daily Check-in (AI-Enhanced)**
*   **Actor**: Patient
*   **Concept**: Replaces static buttons with a natural language input method for more nuanced feedback.
*   **Display Elements**:
    *   Header: "How are you feeling today?"
    *   **Text Input Box**: A large text area with a placeholder, "You can type or speak..."
    *   **Microphone Icon**: For voice-to-text input.
    *   **Detected Mood/Symptom Tag**: Below the text box, a tag appears after the user enters text, e.g., `[Tag: Tired]`, `[Tag: Stressed]`.
    *   "Log Entry" button.
*   **Function**: Allows users to log their daily physical and mental state using free-form text or voice. The AI automatically categorizes the input for trend analysis (related to FR-5.2, FR-5.3).
*   **Screen Flow**:
    *   Accessed via a push notification prompt or from the Home Dashboard.
    *   After logging, the user is returned to the Home Dashboard.

---

### **Section 3: Settings & Personalization**

**Screen 3.1: Settings**
*   **Actor**: Any User
*   **Display Elements**:
    *   Header: "Settings"
    *   **Enable Elder Mode (New)**: A prominent toggle switch. When enabled, a small, persistent "Elder Mode" badge appears in the app's main header.
    *   Profile Settings
    *   Notification Preferences (FR-10.3)
    *   Manage Care Groups
    *   Privacy & Data (FR-10.5)
    *   App Appearance (FR-10.2)
    *   AI Personalization (FR-10.4)
    *   My Subscription (FR-11.2)
    *   Referral Program (FR-11.3)
    *   Export Health Summary (FR-8.1)
    *   Language
    *   Logout
*   **Function**: Central hub for all user-configurable settings.
*   **Screen Flow**: Each option navigates to its respective detailed screen.

**Screen 3.2: Premium Upgrade Screen**
*   **Actor**: Free Tier User
*   **Display Elements**:
    *   Header: "Unlock Your Full Potential"
    *   A visually appealing list comparing Free vs. Premium features (FR-11.1).
    *   Clearly displayed price for the subscription.
    *   "Upgrade Now" button, which initiates the native In-App Purchase flow (FR-11.2).
*   **Function**: To convert free users to paying subscribers.
*   **Screen Flow**: Accessed from various feature-lock points in the app or the Settings screen.

---

## Part 2: Admin Web Portal Mockups

**Screen A.1: Admin Login**
*   **Actor**: System Administrator
*   **Display Elements**:
    *   CareCircle Logo
    *   Email input field
    *   Password input field
    *   "Login" button
*   **Function**: Securely authenticate administrators (FR-9.1).
*   **Screen Flow**: On success -> Navigates to the Main Dashboard (A.2).

**Screen A.2: Main Dashboard**
*   **Actor**: System Administrator
*   **Display Elements**:
    *   **Header**: Logo, Logged-in admin name, Logout button.
    *   **Navigation Sidebar**: Dashboard, User Management, Lead Management, Analytics, Knowledge Base.
    *   **Main Content Area (Widgets)** (FR-9.2):
        *   `System Health`: API Uptime, DB Connection Status (e.g., 99.9% Uptime).
        *   `User Statistics`: Total Users, New Sign-ups (24h), Monthly Active Users.
        *   `Engagement Metrics`: Daily Check-ins Completed, Prescriptions Scanned.
*   **Function**: Provide a high-level overview of the platform's health and key metrics.
*   **Screen Flow**: The landing page after login.

**Screen A.3: User Management**
*   **Actor**: System Administrator
*   **Display Elements**:
    *   Header: "User Management"
    *   Search Bar: "Search by name, email, or user ID" (FR-9.3).
    *   A table of users with columns: User ID, Name, Email, Registration Date, Status (Active/Inactive).
*   **Function**: Allows admins to find and select users for support or review.
*   **Screen Flow**:
    *   Clicking on a user row -> Navigates to User Details screen (A.4).

**Screen A.4: User Details**
*   **Actor**: System Administrator
*   **Display Elements**:
    *   Header: "User: [User Name]"
    *   User's profile information.
    *   Tabs: "Activity Log", "Care Groups", "Support Actions".
    *   **Support Actions Tab**:
        *   Button: "Reset Password"
        *   Button: "Send Notification"
        *   Button: "Deactivate Account"
*   **Function**: Provides a detailed view of a user and tools for customer support (FR-9.3).
*   **Screen Flow**: Accessed from User Management.

**Screen A.5: Lead Management**
*   **Actor**: System Administrator
*   **Display Elements**:
    *   Header: "Lead Management"
    *   Table of leads with columns: Lead ID, Name, Email, Source, Status (New, Contacted, Qualified), Date Added (FR-9.4).
    *   Filters to sort by source or status.
*   **Function**: Manage the pipeline of potential B2B or other leads.
*   **Screen Flow**:
    *   Clicking on a lead -> Navigates to a detail view with an option to convert.
    *   "Convert to User" button -> Navigates to Lead Conversion screen (A.6).

**Screen A.6: Lead Conversion**
*   **Actor**: System Administrator
*   **Display Elements**:
    *   Header: "Convert Lead to User"
    *   Form pre-populated with lead information.
    *   **Duplicate Check (FR-9.5)**: A section that automatically searches for existing users with the same email and displays potential matches.
    *   "Confirm Conversion" button.
*   **Function**: To convert a qualified lead into an active user account.
*   **Screen Flow**: On confirmation, creates the user account and navigates back to the lead list, showing the lead as "Converted".

**Screen A.7: Conversion Analytics**
*   **Actor**: System Administrator
*   **Display Elements**:
    *   Header: "Conversion Analytics"
    *   Date range filter.
    *   Graphs and charts displaying (FR-9.6):
        *   Lead Funnel (New -> Contacted -> Qualified -> Converted).
        *   Conversion Rate Over Time.
        *   Top Lead Sources.
*   **Function**: To track the effectiveness of the lead management process.
*   **Screen Flow**: Accessed from the main navigation sidebar.

**Screen A.8: RAG Knowledge Base Management**
*   **Actor**: System Administrator
*   **Display Elements**:
    *   Header: "Knowledge Base Management"
    *   A list of current data sources (URLs, documents).
    *   Button to "Add New Source" (requires a URL and description).
    *   An indicator showing the last sync status for each source.
*   **Function**: To manage the trusted information sources that power the AI summaries.
*   **Screen Flow**: Accessed from the main navigation sidebar.

---

## Part 3: Elder Mode UI Variants

This section details the screen adaptations when "Elder Mode" is enabled. The goal is to reduce cognitive load, improve readability, and provide simplified controls for users with limited tech proficiency or visual impairments.

### **Screen 4.1: Home Dashboard (Elder Mode)**
*   **Actor**: Elderly Patient
*   **Concept**: A radically simplified version of the main dashboard, focusing only on core, immediate actions.
*   **Visual Style**:
    *   **High Contrast**: Black text on a plain white background.
    *   **Large Fonts**: Minimum 20pt for text, 60pt for buttons.
    *   **Bold Typeface**: For maximum readability.
*   **Display Elements**:
    *   **Header**:
        *   "Elder Mode" badge is always visible.
        *   **Permanent Microphone Icon**: Tapping this reads the screen content aloud or allows for voice commands ("Show my next medication"). A tooltip on first use says "Tap to Speak."
    *   **Main Content Area**:
        *   A single, clear prompt, e.g., "Your next medication is at 2:00 PM."
        *   A large, friendly illustration or photo.
    *   **Bottom Navigation (Simplified)**:
        *   Three large, icon-only buttons replace the standard tab bar:
            1.  `[Icon: Pill]` **Medications**
            2.  `[Icon: Heartbeat]` **Check-In**
            3.  `[Icon: SOS]` **SOS**
*   **Function**: Provides one-tap access to the three most critical functions for this persona. All other features (like settings, profile, etc.) are collapsed into a "More" menu accessible from the Medications screen to avoid clutter.
*   **Haptics**: A gentle "pulse" vibration accompanies all critical reminders.

### **Screen 4.2: Medication Check-off (Elder Mode)**
*   **Actor**: Elderly Patient
*   **Concept**: A full-screen, single-purpose view for confirming medication.
*   **Display Elements**:
    *   **Large Text**: "Did you take your [Medication Name]?"
    *   **Two Huge Buttons**:
        *   `[YES]` (Green background)
        *   `[NOT YET]` (Yellow background)
*   **Function**: Simplifies the medication confirmation process to a single tap, reducing the chance of accidental input.
*   **Screen Flow**:
    *   This screen appears automatically when a medication reminder is due.
    *   Tapping "YES" confirms the dose.
    *   Tapping "NOT YET" snoozes the reminder.
