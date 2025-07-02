# Push Notification Strategy & Scenarios

This document outlines real-life user scenarios and the corresponding push notification strategies, guided by the BRD and mockup documents. The scenarios are grouped by use-case for clarity.

---

### **Core Principles**

*   **Adaptive & Personalized (FR-4.4, FR-10.4)**: The tone, timing, and frequency of notifications will adapt based on the user's persona, historical interactions, and chosen AI communication style.
*   **Actionable (FR-4.2)**: Notifications will provide clear, interactive options to minimize friction.
*   **Context-Aware**: The system will consider the user's status before sending a notification. This includes:
    *   **Quiet Hours**: Suppressing non-critical notifications during user-defined quiet hours.
    *   **Calendar Integration**: Delaying non-urgent reminders if the user's calendar indicates they are "In a Meeting."
    *   **Offline Buffering**: Notifications generated while the user is offline will be queued and delivered once connectivity is restored.
*   **Family-Centric**: Escalation is a key feature, designed to inform and empower caregivers without being intrusive.
*   **User-Controlled**: Users can adjust the AI's notification style and frequency directly in the "AI Personalization" settings (see Mockup Screen 3.1).

---

### **System-Level Rules & Metrics**

*   **Adaptive Engine Parameters (FR-4.4, FR-4.5)**:
    *   **Escalation Cadence**: An escalation to a caregiver is triggered after **two** missed reminders (initial + 1 snooze/follow-up). This is the default and can be configured by the user.
    *   **Response Latency**: The engine will adjust reminder timing based on historical user response times. If a user consistently confirms 5 minutes after a reminder, the system may learn to send it 5 minutes earlier.
    *   **Dynamic Tone Selection**: The engine selects a tone based on user persona and interaction history. A user who responds well to direct prompts will receive more of them, while a user who ignores them may be sent a gentler or more supportive message.
*   **Delivery SLAs**:
    *   **Target**: 90% of push notifications should be delivered to the provider (APNs/FCM) within 5 seconds of the trigger event.
    *   **Retry Logic**: If a notification is not confirmed as delivered by the service, a fallback retry will be attempted at +2 minutes.

---

### **Use-Case: Medication Adherence & Escalation**

This scenario covers the entire lifecycle of a medication reminder, from the initial prompt to caregiver escalation.

*   **Actors**: `Elderly Patient` (Patient), `Family Caregiver` (Caregiver)
*   **Usecase**: The Patient needs to take their daily 8:00 AM blood pressure medication.

**Notification Flow:**

1.  **Initial Reminder (Patient)**
    *   **Time**: 8:00 AM
    *   **Trigger**: Scheduled medication time.
    *   **Content (Tone Selected by Adaptive Engine)**:
        *   *Supportive*: "☀️ Good morning! It's time for your blood pressure medication. Let's stay healthy today!"
        *   *Gentle*: "Just a gentle nudge! It's time for your 8:00 AM medication."
        *   *Direct*: "It is 8:00 AM. Please take your blood pressure medication now."
    *   **Interactive Options**: `[✅ Confirm Taken]` `[⏰ Snooze 15 min]`

2.  **Follow-up / Snooze Reminder (Patient)**
    *   **Time**: 8:15 AM (Or after snooze period ends).
    *   **Trigger**: No interaction with the first notification.
    *   **Content (Tone adapts)**: "Just checking in! Don't forget your 8:00 AM blood pressure medication."
    *   **Interactive Options**: `[✅ Confirm Taken]` `[⏰ Snooze 15 min]`

3.  **Escalation Alert (Caregiver)**
    *   **Time**: 8:30 AM (Based on default rules).
    *   **Trigger**: Patient has not confirmed taking the medication after two reminders.
    *   **Content**: "⚠️ **Action Needed**: Mom has missed her 8:00 AM medication reminder. Please check in with her."
    *   **Interactive Options**: `[📞 Call Mom]` `[💬 Message Mom]`

4.  **Patient Status Update**
    *   The Patient's RAG health status indicator on the Home Dashboard (Screen 2.1) shifts to **Amber** to reflect the missed dose.

---

### **Use-Case: Daily Check-ins & Symptom Alerts**

*   **Actors**: `Patient`, `Caregiver`
*   **Usecase**: The system prompts the Patient for their daily check-in, and they report feeling unwell.

**Notification Flow:**

1.  **Check-in Prompt (Patient)**
    *   **Time**: 10:00 AM (Optimized by Adaptive Engine - FR-5.1).
    *   **Trigger**: Daily scheduled check-in.
    *   **Content**: "Time for your daily check-in! How are you feeling today?"
    *   **Interactive Options (FR-5.2)**: `[😊 Good]` `[😐 Okay]` `[🤒 Not Well]`

2.  **Caregiver Alert (If "Not Well")**
    *   **Time**: Immediately after Patient reports "Not Well" and specifies a symptom.
    *   **Trigger**: Patient reports feeling unwell.
    *   **Content**: "Heads up: Dad reported feeling 'Not Well' during his daily check-in and mentioned 'Dizziness'. You may want to follow up."
    *   **Interactive Options**: `[View Check-in Details]` `[📞 Call Dad]`

---

### **Use-Case: Proactive AI & Health Insights**

*   **Actors**: `Any User`
*   **Usecase**: The AI engine identifies a trend or risk and proactively notifies the user.

**Notification Scenarios:**

1.  **Weekly Health Summary**
    *   **Trigger**: End of the week.
    *   **Content**: "Here's your weekly health snapshot! You've hit 95% medication adherence and your average sleep quality is up by 10%. Tap to see the full summary."
    *   **Action**: Links to the AI-generated summary screen.

2.  **Predictive Alert**
    *   **Trigger**: AI engine detects a statistically significant negative trend.
    *   **Content**: "Just noticed a pattern: your blood pressure trend has been increasing over the last 3 days. Consider doing a manual check-in or scheduling a visit."
    *   **Action**: Links to the blood pressure tracking chart.

3.  **Positive Reinforcement Insight**
    *   **Trigger**: AI engine identifies a positive correlation.
    *   **Content**: "Great work! On days you walk over 8,000 steps, your sleep quality improves by an average of 20%. Keep it up!"
    *   **Action**: Links to the goal-setting screen.

---

### **Use-Case: Elder Mode**

*   **Actors**: `Elderly Patient`
*   **Usecase**: Notifications are adapted for users who have enabled Elder Mode for higher accessibility.

**Notification Scenarios:**

1.  **Voice-First Reminders (TTS)**
    *   **Trigger**: Any medication or check-in reminder.
    *   **Behavior**: The notification content is read aloud via Text-to-Speech (TTS). The reminder sound and voice prompt will repeat twice, with a 30-second gap, to ensure it's heard.
    *   **Content**: *(Voice)* "It is time for your 8:00 AM medication."

2.  **Haptic Confirmation**
    *   **Trigger**: A reminder is sent to a user with a connected wearable (e.g., Apple Watch).
    *   **Behavior**: The device will emit a distinct, gentle vibration pattern to provide a non-auditory cue.

---

### **Use-Case: Care Coordination & Data Sharing**

*   **Actors**: `Patient`, `Caregiver`
*   **Usecase**: Notifications that facilitate communication and data sharing within the care group or with professionals.

**Notification Scenarios:**

1.  **Caregiver Check-in Prompt**
    *   **Trigger**: Two medication reminders have been missed by the patient.
    *   **Content**: "It looks like you're having trouble. Would you like to call your caregiver for you?"
    *   **Interactive Options**: `[Yes, call them via Zalo]` `[No, I'm okay]`

2.  **Monthly Export Nudge**
    *   **Trigger**: First day of the month.
    *   **Content**: "A new month is here! Don't forget to share your monthly health report with your doctor. Tap here to export it."
    *   **Action**: Links directly to the PDF export flow (FR-2.1).

3.  **Temporary Data Sharing Transparency**
    *   **Trigger**: A caregiver grants temporary health data access to a third party (FR-10.5).
    *   **Recipient**: Patient
    *   **Content**: "FYI: [Caregiver's Name] has shared a temporary, 48-hour health summary with doctor@clinic.com. You can revoke this access at any time."

---

### **Use-Case: Engagement, Growth & Retention**

*   **Actors**: `Any User`
*   **Usecase**: Notifications designed to encourage continued app usage, reward positive behavior, and drive growth.

**Notification Scenarios:**

1.  **Gamification Milestone**
    *   **Trigger**: Achieving a milestone (e.g., 7-day adherence streak - FR-12.2).
    *   **Content**: "On a roll! You've hit a 7-day streak and earned the 'Adherence Champion' badge. You're unstoppable! 🏆"
    *   **Action**: `[View My Badges]`

2.  **Streak Freeze Offer**
    *   **Trigger**: A user with a streak > 5 days misses a medication confirmation.
    *   **Content**: "Your 7-day streak is at risk! Need a 'Streak Freeze' for today? Tap to activate your grace day."
    *   **Action**: `[❄️ Activate Freeze]`

3.  **Referral Program (FR-11.3)**
    *   **Trigger**: A new user signs up using a referral code.
    *   **Recipient**: The original user (the referrer).
    *   **Content**: "🎉 Success! Your friend has joined CareCircle. You've both earned one free month of Premium!"

---

### **Use-Case: Multi-Dependent Management**

*   **Actors**: `Sandwich Generation Caregiver`
*   **Usecase**: Consolidating information for caregivers managing multiple dependents.

**Notification Flow:**

1.  **The Daily Digest**
    *   **Time**: 7:00 PM (Configurable).
    *   **Trigger**: End-of-day summary.
    *   **Content**: "Your Family Health Digest for today: **Dad** took both his meds on time. **Son** took his afternoon inhaler after one reminder. Everyone is on track! ✨"
    *   **Function**: This consolidates multiple status updates into one summary to reduce notification fatigue.

---

### **Use-Case: Community & Public Health**

*   **Actor**: `Any User`
*   **Usecase**: Leveraging the platform for broader public health awareness.

**Notification Flow:**

1.  **Proactive Health Bulletin**
    *   **Trigger**: Admin publishes a new alert in the Knowledge Base Management portal (Screen A.8).
    *   **Recipient**: All users located in the affected city.
    *   **Content**: "Public Health Alert for your area: Air quality is currently poor. Those with respiratory conditions should take extra care. Tap to see tips."
    *   **Function**: Transforms the app into a proactive community health partner (FR-7.3).

---

### Use-Case: E-Pharmacy & Refills

*   **Actors**: `Patient`, `Caregiver`
*   **Usecase**: The system proactively reminds the user to refill a prescription that is running low.

**Notification Flow:**

1.  **Low Medication Alert**
    *   **Trigger**: The system calculates that a user has less than 3 days of a specific medication remaining.
    *   **Content**: "Heads up! You have about 3 days of Metformin left. Tap here to request a refill from one of our partners."
    *   **Interactive Options**: `[Request Refill]` `[Remind Me Tomorrow]`
    *   **Action**: Tapping `[Request Refill]` opens the E-Pharmacy selection flow (Mockup E.1).

---

### Use-Case: New Prescription Added

*   **Actors**: `Patient`, `Caregiver`
*   **Usecase**: Confirming a newly added prescription and offering to set up reminders.

**Notification Flow:**

1.  **Prescription Confirmation**
    *   **Trigger**: A new medication is successfully added via OCR scan or manual entry.
    *   **Content**: "Great! We've added [Medication Name] to your list. Would you like to set up reminders now?"
    *   **Interactive Options**: `[Set Reminders]` `[Later]`
    *   **Action**: Tapping `[Set Reminders]` navigates to the medication scheduling screen.

---

### Use-Case: Abnormal Vital Reading

*   **Actors**: `Patient`, `Caregiver`
*   **Usecase**: Alerting users and caregivers about vital readings outside the normal range.

**Notification Flow:**

1.  **Abnormal Reading Alert (Patient)**
    *   **Trigger**: A synced or manually entered vital reading (e.g., blood pressure, blood glucose) is outside the user's personalized normal range.
    *   **Content**: "⚠️ Your blood pressure reading (145/95 mmHg) is higher than usual. Consider re-measuring or consulting your doctor."
    *   **Interactive Options**: `[Log New Reading]` `[View Trends]`

2.  **Abnormal Reading Alert (Caregiver)**
    *   **Trigger**: If the patient's reading remains abnormal after a set period, or if it's critically high/low.
    *   **Content**: "🚨 **Urgent**: [Patient Name]'s blood pressure is critically high (160/100 mmHg). Please check in immediately."
    *   **Interactive Options**: `[Call Patient]` `[View Details]`

---

### Use-Case: Care Group Invitation Accepted

*   **Actors**: `Care Group Administrator`
*   **Usecase**: Notifying the administrator when a new member accepts their invitation and is approved.

**Notification Flow:**

1.  **New Member Joined**
    *   **Trigger**: A user accepts a Care Group invitation and is approved by an administrator.
    *   **Content**: "🎉 [New Member Name] has joined your Care Group! You can now see their shared health data."
    *   **Action**: Links to the Care Group details screen.

---

### Use-Case: Health Goal Achievement/Progress

*   **Actors**: `Any User`
*   **Usecase**: Encouraging users by celebrating their progress towards health goals.

**Notification Flow:**

1.  **Goal Progress Update**
    *   **Trigger**: User reaches a significant milestone towards a defined health goal (e.g., 50% complete, 75% complete).
    *   **Content**: "You're halfway to your 5,000 steps goal today! Keep up the great work! 💪"
    *   **Action**: Links to the goal tracking dashboard.

2.  **Goal Achieved**
    *   **Trigger**: User successfully achieves a health goal.
    *   **Content**: "Congratulations! You've crushed your goal of walking 5,000 steps every day this week! What's next?"
    *   **Interactive Options**: `[Set New Goal]` `[Share Achievement]`

---

### Use-Case: System Maintenance/Update Notification

*   **Actors**: `Any User`
*   **Usecase**: Informing users about planned system maintenance, new features, or important app updates.

**Notification Flow:**

1.  **Planned Maintenance Alert**
    *   **Trigger**: Scheduled system maintenance.
    *   **Content**: "Heads up! CareCircle will be undergoing planned maintenance on [Date] from [Time] to [Time]. Services may be temporarily unavailable."
    *   **Action**: Links to a status page or in-app announcement.

2.  **New Feature Announcement**
    *   **Trigger**: Release of a significant new feature.
    *   **Content**: "Exciting news! We've just launched [New Feature Name]! Now you can [brief benefit]. Tap to learn more!"
    *   **Action**: Links to an in-app tutorial or feature highlight.