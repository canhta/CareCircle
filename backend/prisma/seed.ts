import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Starting database seeding...');

  // Create a demo user (without password for demo purposes)
  const demoUser = await prisma.user.upsert({
    where: { email: 'demo@carecircle.com' },
    update: {},
    create: {
      email: 'demo@carecircle.com',
      firstName: 'Demo',
      lastName: 'User',
      phone: '+1234567890',
      emailVerified: true,
      isActive: true,
    },
  });

  console.log('✅ Created demo user:', demoUser.email);

  // Create some sample health records
  await prisma.healthRecord.createMany({
    data: [
      {
        userId: demoUser.id,
        dataType: 'HEART_RATE',
        value: 72,
        unit: 'bpm',
        recordedAt: new Date(),
        source: 'MANUAL',
      },
      {
        userId: demoUser.id,
        dataType: 'WEIGHT',
        value: 70.5,
        unit: 'kg',
        recordedAt: new Date(),
        source: 'MANUAL',
      },
      {
        userId: demoUser.id,
        dataType: 'BLOOD_PRESSURE_SYSTOLIC',
        value: 120,
        unit: 'mmHg',
        recordedAt: new Date(),
        source: 'MANUAL',
      },
      {
        userId: demoUser.id,
        dataType: 'BLOOD_PRESSURE_DIASTOLIC',
        value: 80,
        unit: 'mmHg',
        recordedAt: new Date(),
        source: 'MANUAL',
      },
    ],
  });

  console.log('✅ Created sample health records');

  // Create a sample prescription
  const prescription = await prisma.prescription.create({
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

  console.log('✅ Created sample prescription:', prescription.medicationName);

  // Create a care group
  const careGroup = await prisma.careGroup.create({
    data: {
      name: 'Demo Family Care Circle',
      description: 'A demo care group for family members',
      inviteCode: 'DEMO123',
    },
  });

  // Add the demo user to the care group as owner
  await prisma.careGroupMember.create({
    data: {
      careGroupId: careGroup.id,
      userId: demoUser.id,
      role: 'OWNER',
      canViewHealth: true,
      canReceiveAlerts: true,
      canManageSettings: true,
    },
  });

  console.log('✅ Created demo care group:', careGroup.name);

  // Create a daily check-in
  await prisma.dailyCheckIn.create({
    data: {
      userId: demoUser.id,
      date: new Date(),
      moodScore: 8,
      energyLevel: 7,
      sleepQuality: 8,
      painLevel: 2,
      stressLevel: 3,
      symptoms: ['Minor headache'],
      notes: 'Feeling good overall, had a great workout this morning',
      completed: true,
      completedAt: new Date(),
    },
  });

  console.log('✅ Created sample daily check-in');

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
