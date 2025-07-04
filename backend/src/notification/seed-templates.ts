import {
  PrismaClient,
  NotificationType,
  NotificationChannel,
  NotificationPriority,
} from '@prisma/client';

const prisma = new PrismaClient();

export async function seedNotificationTemplates() {
  const templates = [
    // Medication Reminder Templates
    {
      name: 'medication_reminder_default',
      description: 'Default medication reminder template',
      type: NotificationType.MEDICATION_REMINDER,
      titleTemplate: '💊 Time for {{medicationName}}',
      messageTemplate:
        "Hi {{userName}}, it's time to take your {{medicationName}} ({{dosage}}). Don't forget to take it as prescribed!",
      placeholders: [
        {
          key: 'userName',
          type: 'string',
          required: true,
          description: "User's name",
        },
        {
          key: 'medicationName',
          type: 'string',
          required: true,
          description: 'Name of the medication',
        },
        {
          key: 'dosage',
          type: 'string',
          required: true,
          description: 'Dosage information',
        },
      ],
      channels: [NotificationChannel.PUSH, NotificationChannel.IN_APP],
      defaultPriority: NotificationPriority.HIGH,
      language: 'en',
    },
    {
      name: 'medication_reminder_friendly',
      description: 'Friendly medication reminder template',
      type: NotificationType.MEDICATION_REMINDER,
      titleTemplate: '🌟 {{userName}}, your health matters!',
      messageTemplate:
        'Hey {{userName}}! Just a gentle reminder to take your {{medicationName}} ({{dosage}}). Your wellbeing is important to us. 💙',
      placeholders: [
        {
          key: 'userName',
          type: 'string',
          required: true,
          description: "User's name",
        },
        {
          key: 'medicationName',
          type: 'string',
          required: true,
          description: 'Name of the medication',
        },
        {
          key: 'dosage',
          type: 'string',
          required: true,
          description: 'Dosage information',
        },
      ],
      channels: [NotificationChannel.PUSH, NotificationChannel.IN_APP],
      defaultPriority: NotificationPriority.HIGH,
      language: 'en',
    },
    {
      name: 'medication_reminder_urgent',
      description: 'Urgent medication reminder template',
      type: NotificationType.MEDICATION_REMINDER,
      titleTemplate: '🚨 URGENT: {{medicationName}} Reminder',
      messageTemplate:
        "{{userName}}, you haven't taken your {{medicationName}} yet. This medication is important for your health. Please take {{dosage}} now.",
      placeholders: [
        {
          key: 'userName',
          type: 'string',
          required: true,
          description: "User's name",
        },
        {
          key: 'medicationName',
          type: 'string',
          required: true,
          description: 'Name of the medication',
        },
        {
          key: 'dosage',
          type: 'string',
          required: true,
          description: 'Dosage information',
        },
      ],
      channels: [
        NotificationChannel.PUSH,
        NotificationChannel.IN_APP,
        NotificationChannel.SMS,
      ],
      defaultPriority: NotificationPriority.CRITICAL,
      language: 'en',
    },

    // Check-in Reminder Templates
    {
      name: 'checkin_reminder_default',
      description: 'Default daily check-in reminder',
      type: NotificationType.CHECK_IN_REMINDER,
      titleTemplate: '🏥 Daily Health Check-in',
      messageTemplate:
        "Hi {{userName}}, how are you feeling today? Take a moment to log your health status and let your care team know how you're doing.",
      placeholders: [
        {
          key: 'userName',
          type: 'string',
          required: true,
          description: "User's name",
        },
      ],
      channels: [NotificationChannel.PUSH, NotificationChannel.IN_APP],
      defaultPriority: NotificationPriority.NORMAL,
      language: 'en',
    },
    {
      name: 'checkin_reminder_motivational',
      description: 'Motivational daily check-in reminder',
      type: NotificationType.CHECK_IN_REMINDER,
      titleTemplate: "✨ {{userName}}, you've got this!",
      messageTemplate:
        "Good {{timeOfDay}}, {{userName}}! Take a moment to check in with yourself. Your health journey matters, and we're here to support you every step of the way.",
      placeholders: [
        {
          key: 'userName',
          type: 'string',
          required: true,
          description: "User's name",
        },
        {
          key: 'timeOfDay',
          type: 'string',
          required: false,
          description: 'Time of day (morning, afternoon, evening)',
        },
      ],
      channels: [NotificationChannel.PUSH, NotificationChannel.IN_APP],
      defaultPriority: NotificationPriority.NORMAL,
      language: 'en',
    },

    // Care Group Templates
    {
      name: 'care_group_invitation',
      description: 'Care group invitation template',
      type: NotificationType.CARE_GROUP_UPDATE,
      titleTemplate: "👥 You're invited to join {{careGroupName}}",
      messageTemplate:
        'Hi {{userName}}, {{inviterName}} has invited you to join the {{careGroupName}} care group. Connect with your loved ones and share your health journey together.',
      placeholders: [
        {
          key: 'userName',
          type: 'string',
          required: true,
          description: "User's name",
        },
        {
          key: 'careGroupName',
          type: 'string',
          required: true,
          description: 'Name of the care group',
        },
        {
          key: 'inviterName',
          type: 'string',
          required: true,
          description: 'Name of the person who sent the invitation',
        },
      ],
      channels: [
        NotificationChannel.PUSH,
        NotificationChannel.IN_APP,
        NotificationChannel.EMAIL,
      ],
      defaultPriority: NotificationPriority.NORMAL,
      language: 'en',
    },
    {
      name: 'care_group_update',
      description: 'General care group update template',
      type: NotificationType.CARE_GROUP_UPDATE,
      titleTemplate: '📋 Update from {{careGroupName}}',
      messageTemplate:
        "Hello {{userName}}, there's new activity in {{careGroupName}}. Stay connected with your care circle and check out the latest updates.",
      placeholders: [
        {
          key: 'userName',
          type: 'string',
          required: true,
          description: "User's name",
        },
        {
          key: 'careGroupName',
          type: 'string',
          required: true,
          description: 'Name of the care group',
        },
      ],
      channels: [NotificationChannel.PUSH, NotificationChannel.IN_APP],
      defaultPriority: NotificationPriority.NORMAL,
      language: 'en',
    },

    // Health Alert Templates
    {
      name: 'health_alert_default',
      description: 'Default health alert template',
      type: NotificationType.HEALTH_ALERT,
      titleTemplate: '⚠️ Health Alert',
      messageTemplate:
        "Hi {{userName}}, we've detected something that needs your attention: {{alertMessage}}. Please review your health data and consult with your healthcare provider if needed.",
      placeholders: [
        {
          key: 'userName',
          type: 'string',
          required: true,
          description: "User's name",
        },
        {
          key: 'alertMessage',
          type: 'string',
          required: true,
          description: 'Alert message content',
        },
      ],
      channels: [NotificationChannel.PUSH, NotificationChannel.IN_APP],
      defaultPriority: NotificationPriority.HIGH,
      language: 'en',
    },

    // AI Insight Templates
    {
      name: 'ai_insight_weekly',
      description: 'Weekly AI-generated health insights',
      type: NotificationType.AI_INSIGHT,
      titleTemplate: '🧠 Your Weekly Health Insights',
      messageTemplate:
        'Hi {{userName}}, here are your personalized health insights for this week: {{insightSummary}}. Keep up the great work on your health journey!',
      placeholders: [
        {
          key: 'userName',
          type: 'string',
          required: true,
          description: "User's name",
        },
        {
          key: 'insightSummary',
          type: 'string',
          required: true,
          description: 'AI-generated insight summary',
        },
      ],
      channels: [
        NotificationChannel.PUSH,
        NotificationChannel.IN_APP,
        NotificationChannel.EMAIL,
      ],
      defaultPriority: NotificationPriority.NORMAL,
      language: 'en',
    },
  ];

  for (const template of templates) {
    try {
      await prisma.notificationTemplate.upsert({
        where: { name: template.name },
        update: template,
        create: template,
      });
      console.log(`✅ Created/updated template: ${template.name}`);
    } catch (error) {
      console.error(`❌ Failed to create template ${template.name}:`, error);
    }
  }
}

// Run the seed function if this file is executed directly
if (require.main === module) {
  seedNotificationTemplates()
    .then(() => {
      console.log('🎉 Notification templates seeded successfully!');
      process.exit(0);
    })
    .catch((error) => {
      console.error('❌ Error seeding notification templates:', error);
      process.exit(1);
    })
    .finally(() => {
      prisma.$disconnect();
    });
}
