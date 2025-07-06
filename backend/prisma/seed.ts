import {
  PrismaClient,
  Gender,
  SystemRole,
  HealthDataType,
  NotificationType,
  NotificationChannel,
  NotificationPriority,
} from '@prisma/client';
import { seedNotificationTemplates } from '../src/notification/seed-templates';
import { hash } from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Starting database seeding...');

  // Create demo users with hashed passwords
  const adminPassword = await hash('admin123', 10);
  const userPassword = await hash('user123', 10);

  // Create an admin user
  const adminUser = await prisma.user.upsert({
    where: { email: 'admin@carecircle.com' },
    update: {},
    create: {
      email: 'admin@carecircle.com',
      password: adminPassword,
      firstName: 'Admin',
      lastName: 'User',
      phone: '+1234567890',
      emailVerified: true,
      isActive: true,
      roles: [SystemRole.ADMIN],
      dataProcessingConsent: true,
      consentVersion: '1.0',
      consentDate: new Date(),
    },
  });

  console.log('✅ Created admin user:', adminUser.email);

  // Create demo user
  const demoUser = await prisma.user.upsert({
    where: { email: 'demo@carecircle.com' },
    update: {},
    create: {
      email: 'demo@carecircle.com',
      password: userPassword,
      firstName: 'Demo',
      lastName: 'User',
      phone: '+1234567890',
      dateOfBirth: new Date('1990-01-01'),
      gender: Gender.MALE,
      emailVerified: true,
      isActive: true,
      dataProcessingConsent: true,
      marketingConsent: true,
      analyticsConsent: true,
      healthDataSharingConsent: true,
      consentVersion: '1.0',
      consentDate: new Date(),
    },
  });

  console.log('✅ Created demo user:', demoUser.email);

  // Create caregiver user
  const caregiverUser = await prisma.user.upsert({
    where: { email: 'caregiver@carecircle.com' },
    update: {},
    create: {
      email: 'caregiver@carecircle.com',
      password: userPassword,
      firstName: 'Care',
      lastName: 'Giver',
      phone: '+1987654321',
      emailVerified: true,
      isActive: true,
      roles: [SystemRole.HEALTHCARE_PROVIDER],
      dataProcessingConsent: true,
      consentVersion: '1.0',
      consentDate: new Date(),
    },
  });

  console.log('✅ Created caregiver user:', caregiverUser.email);

  // Clean up existing demo data for fresh seeding
  await prisma.healthRecord.deleteMany({
    where: { userId: demoUser.id },
  });

  await prisma.prescription.deleteMany({
    where: { userId: demoUser.id },
  });

  await prisma.dailyCheckIn.deleteMany({
    where: { userId: demoUser.id },
  });

  await prisma.careGroupMember.deleteMany({
    where: { userId: { in: [demoUser.id, caregiverUser.id] } },
  });

  await prisma.careGroup.deleteMany({
    where: { inviteCode: 'DEMO123' },
  });

  // Create some sample health records
  const now = new Date();
  const yesterday = new Date(now);
  yesterday.setDate(yesterday.getDate() - 1);

  await prisma.healthRecord.createMany({
    data: [
      {
        userId: demoUser.id,
        dataType: HealthDataType.HEART_RATE,
        value: 72,
        unit: 'bpm',
        recordedAt: now,
        source: 'MANUAL',
        year: now.getFullYear(),
        month: now.getMonth() + 1,
        day: now.getDate(),
      },
      {
        userId: demoUser.id,
        dataType: HealthDataType.WEIGHT,
        value: 70.5,
        unit: 'kg',
        recordedAt: now,
        source: 'MANUAL',
        year: now.getFullYear(),
        month: now.getMonth() + 1,
        day: now.getDate(),
      },
      {
        userId: demoUser.id,
        dataType: HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
        value: 120,
        unit: 'mmHg',
        recordedAt: now,
        source: 'MANUAL',
        year: now.getFullYear(),
        month: now.getMonth() + 1,
        day: now.getDate(),
      },
      {
        userId: demoUser.id,
        dataType: HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
        value: 80,
        unit: 'mmHg',
        recordedAt: now,
        source: 'MANUAL',
        year: now.getFullYear(),
        month: now.getMonth() + 1,
        day: now.getDate(),
      },
      // Yesterday's data
      {
        userId: demoUser.id,
        dataType: HealthDataType.HEART_RATE,
        value: 68,
        unit: 'bpm',
        recordedAt: yesterday,
        source: 'MANUAL',
        year: yesterday.getFullYear(),
        month: yesterday.getMonth() + 1,
        day: yesterday.getDate(),
      },
      {
        userId: demoUser.id,
        dataType: HealthDataType.WEIGHT,
        value: 70.8,
        unit: 'kg',
        recordedAt: yesterday,
        source: 'MANUAL',
        year: yesterday.getFullYear(),
        month: yesterday.getMonth() + 1,
        day: yesterday.getDate(),
      },
    ],
  });

  console.log('✅ Created sample health records');

  // Create a health metrics entry
  await prisma.healthMetrics.upsert({
    where: {
      userId_date: {
        userId: demoUser.id,
        date: now,
      },
    },
    update: {},
    create: {
      userId: demoUser.id,
      date: now,
      steps: 8500,
      distance: 6.2,
      caloriesBurned: 420,
      activeMinutes: 45,
      sleepDuration: 440,
      deepSleepDuration: 120,
      remSleepDuration: 90,
      sleepScore: 85,
      heartRateResting: 65,
      heartRateAvg: 72,
      bloodPressureSys: 120,
      bloodPressureDia: 80,
      syncSource: 'MANUAL',
      dataQuality: 'GOOD',
    },
  });

  console.log('✅ Created health metrics');

  // Create sample prescriptions
  const prescription1 = await prisma.prescription.create({
    data: {
      userId: demoUser.id,
      medicationName: 'Lisinopril',
      dosage: '10mg',
      frequency: 'Once daily',
      instructions: 'Take with food, preferably in the morning',
      startDate: new Date(),
      endDate: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000), // 30 days from now
      prescribedBy: 'Dr. Smith',
      pharmacy: 'Local Pharmacy',
      refillsLeft: 3,
      isVerified: true,
    },
  });

  const prescription2 = await prisma.prescription.create({
    data: {
      userId: demoUser.id,
      medicationName: 'Metformin',
      dosage: '500mg',
      frequency: 'Twice daily',
      instructions: 'Take with meals',
      startDate: new Date(),
      endDate: new Date(Date.now() + 60 * 24 * 60 * 60 * 1000), // 60 days from now
      prescribedBy: 'Dr. Johnson',
      pharmacy: 'City Pharmacy',
      refillsLeft: 5,
      isVerified: true,
    },
  });

  console.log('✅ Created sample prescriptions');

  // Create reminder for prescription
  await prisma.reminder.create({
    data: {
      prescriptionId: prescription1.id,
      scheduledAt: new Date(now.setHours(8, 0, 0, 0)), // 8:00 AM
      isRecurring: true,
      frequency: 'daily',
    },
  });

  await prisma.reminder.create({
    data: {
      prescriptionId: prescription2.id,
      scheduledAt: new Date(now.setHours(8, 0, 0, 0)), // 8:00 AM
      isRecurring: true,
      frequency: 'daily',
    },
  });

  await prisma.reminder.create({
    data: {
      prescriptionId: prescription2.id,
      scheduledAt: new Date(now.setHours(20, 0, 0, 0)), // 8:00 PM
      isRecurring: true,
      frequency: 'daily',
    },
  });

  console.log('✅ Created medication reminders');

  // Create a care group
  const careGroup = await prisma.careGroup.upsert({
    where: { inviteCode: 'DEMO123' },
    update: {},
    create: {
      name: 'Demo Family Care Circle',
      description: 'A demo care group for family members',
      inviteCode: 'DEMO123',
    },
  });

  // Add the demo user to the care group as owner
  await prisma.careGroupMember.upsert({
    where: {
      careGroupId_userId: {
        careGroupId: careGroup.id,
        userId: demoUser.id,
      },
    },
    update: {},
    create: {
      careGroupId: careGroup.id,
      userId: demoUser.id,
      role: 'OWNER',
      canViewHealth: true,
      canReceiveAlerts: true,
      canManageSettings: true,
    },
  });

  // Add the caregiver to the care group
  await prisma.careGroupMember.upsert({
    where: {
      careGroupId_userId: {
        careGroupId: careGroup.id,
        userId: caregiverUser.id,
      },
    },
    update: {},
    create: {
      careGroupId: careGroup.id,
      userId: caregiverUser.id,
      role: 'CAREGIVER',
      canViewHealth: true,
      canReceiveAlerts: true,
      canManageSettings: false,
    },
  });

  console.log('✅ Created demo care group:', careGroup.name);

  // Create daily check-ins
  await prisma.dailyCheckIn.upsert({
    where: {
      userId_date: {
        userId: demoUser.id,
        date: now,
      },
    },
    update: {},
    create: {
      userId: demoUser.id,
      date: now,
      moodScore: 8,
      energyLevel: 7,
      sleepQuality: 8,
      painLevel: 2,
      stressLevel: 3,
      symptoms: ['Minor headache'],
      notes: 'Feeling good overall, had a great workout this morning',
      completed: true,
      completedAt: now,
    },
  });

  await prisma.dailyCheckIn.upsert({
    where: {
      userId_date: {
        userId: demoUser.id,
        date: yesterday,
      },
    },
    update: {},
    create: {
      userId: demoUser.id,
      date: yesterday,
      moodScore: 6,
      energyLevel: 5,
      sleepQuality: 5,
      painLevel: 4,
      stressLevel: 6,
      symptoms: ['Headache', 'Fatigue'],
      notes: 'Felt tired today, might be coming down with something',
      completed: true,
      completedAt: yesterday,
    },
  });

  console.log('✅ Created sample daily check-ins');

  // Create a sample document
  await prisma.document.create({
    data: {
      userId: demoUser.id,
      title: 'Medical History',
      category: 'MEDICAL_RECORD',
      fileUrl: 'https://example.com/demo-medical-history.pdf',
      fileName: 'medical-history.pdf',
      fileType: 'application/pdf',
      fileSize: 2048000,
    },
  });

  console.log('✅ Created sample document');

  // Create a notification for demo user
  await prisma.notification.create({
    data: {
      userId: demoUser.id,
      type: NotificationType.MEDICATION_REMINDER,
      title: '💊 Time for Lisinopril',
      message:
        "Hi Demo, it's time to take your Lisinopril (10mg). Don't forget to take it as prescribed!",
      channel: [NotificationChannel.IN_APP],
      priority: NotificationPriority.HIGH,
    },
  });

  console.log('✅ Created sample notification');

  // Delete existing device tokens for the demo user
  await prisma.deviceToken.deleteMany({
    where: {
      userId: demoUser.id,
      token: 'demo-fcm-token-example',
    },
  });

  // Create a device token for demo user
  await prisma.deviceToken.create({
    data: {
      userId: demoUser.id,
      token: 'demo-fcm-token-example',
      deviceType: 'android',
      deviceInfo: JSON.stringify({
        model: 'Pixel 6',
        manufacturer: 'Google',
        osVersion: 'Android 13',
        appVersion: '1.0.0',
      }),
      isActive: true,
    },
  });

  console.log('✅ Created device token');

  // Seed notification templates
  console.log('🌱 Seeding notification templates...');
  await seedNotificationTemplates();
  console.log('✅ Notification templates seeded');

  console.log('🎉 Database seeding completed successfully!');
}

main()
  .catch((e) => {
    console.error('❌ Error during seeding:', e);
    process.exit(1);
  })
  .finally(() => {
    void prisma.$disconnect();
  });
