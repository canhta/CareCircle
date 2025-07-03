-- CreateEnum
CREATE TYPE "Gender" AS ENUM ('MALE', 'FEMALE', 'OTHER', 'PREFER_NOT_TO_SAY');

-- CreateEnum
CREATE TYPE "HealthDataType" AS ENUM ('HEART_RATE', 'BLOOD_PRESSURE_SYSTOLIC', 'BLOOD_PRESSURE_DIASTOLIC', 'WEIGHT', 'HEIGHT', 'BMI', 'BLOOD_GLUCOSE', 'STEPS', 'SLEEP_HOURS', 'EXERCISE_MINUTES', 'CALORIES_BURNED', 'OXYGEN_SATURATION', 'BODY_TEMPERATURE');

-- CreateEnum
CREATE TYPE "DataSource" AS ENUM ('MANUAL', 'APPLE_HEALTH', 'GOOGLE_FIT', 'DEVICE_SYNC');

-- CreateEnum
CREATE TYPE "ReminderStatus" AS ENUM ('PENDING', 'SENT', 'ACKNOWLEDGED', 'MISSED', 'FAILED');

-- CreateEnum
CREATE TYPE "CareRole" AS ENUM ('OWNER', 'ADMIN', 'CAREGIVER', 'MEMBER');

-- CreateEnum
CREATE TYPE "NotificationType" AS ENUM ('MEDICATION_REMINDER', 'HEALTH_ALERT', 'CHECK_IN_REMINDER', 'CARE_GROUP_UPDATE', 'SYSTEM_NOTIFICATION', 'AI_INSIGHT');

-- CreateEnum
CREATE TYPE "NotificationChannel" AS ENUM ('PUSH', 'EMAIL', 'SMS', 'IN_APP');

-- CreateEnum
CREATE TYPE "NotificationPriority" AS ENUM ('LOW', 'NORMAL', 'HIGH', 'CRITICAL');

-- CreateEnum
CREATE TYPE "DocumentCategory" AS ENUM ('PRESCRIPTION', 'LAB_RESULT', 'MEDICAL_REPORT', 'INSURANCE', 'EMERGENCY_CONTACT', 'OTHER');

-- CreateTable
CREATE TABLE "users" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT,
    "firstName" TEXT NOT NULL,
    "lastName" TEXT NOT NULL,
    "phone" TEXT,
    "dateOfBirth" TIMESTAMP(3),
    "gender" "Gender",
    "timezone" TEXT NOT NULL DEFAULT 'UTC',
    "emailVerified" BOOLEAN NOT NULL DEFAULT false,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "lastLoginAt" TIMESTAMP(3),
    "googleId" TEXT,
    "appleId" TEXT,
    "avatar" TEXT,
    "emergencyContact" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "health_records" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "dataType" "HealthDataType" NOT NULL,
    "value" DOUBLE PRECISION NOT NULL,
    "unit" TEXT NOT NULL,
    "recordedAt" TIMESTAMP(3) NOT NULL,
    "source" "DataSource" NOT NULL,
    "deviceId" TEXT,
    "confidence" DOUBLE PRECISION,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "health_records_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "prescriptions" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "medicationName" TEXT NOT NULL,
    "dosage" TEXT NOT NULL,
    "frequency" TEXT NOT NULL,
    "instructions" TEXT,
    "startDate" TIMESTAMP(3) NOT NULL,
    "endDate" TIMESTAMP(3),
    "ocrImageUrl" TEXT,
    "ocrConfidence" DOUBLE PRECISION,
    "isVerified" BOOLEAN NOT NULL DEFAULT false,
    "refillsLeft" INTEGER,
    "pharmacy" TEXT,
    "prescribedBy" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "prescriptions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "reminders" (
    "id" TEXT NOT NULL,
    "prescriptionId" TEXT NOT NULL,
    "scheduledAt" TIMESTAMP(3) NOT NULL,
    "isRecurring" BOOLEAN NOT NULL DEFAULT true,
    "frequency" TEXT,
    "status" "ReminderStatus" NOT NULL DEFAULT 'PENDING',
    "sentAt" TIMESTAMP(3),
    "acknowledgedAt" TIMESTAMP(3),
    "retryCount" INTEGER NOT NULL DEFAULT 0,
    "maxRetries" INTEGER NOT NULL DEFAULT 3,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "reminders_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "care_groups" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "inviteCode" TEXT NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "care_groups_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "care_group_members" (
    "id" TEXT NOT NULL,
    "careGroupId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "role" "CareRole" NOT NULL DEFAULT 'MEMBER',
    "joinedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "canViewHealth" BOOLEAN NOT NULL DEFAULT false,
    "canReceiveAlerts" BOOLEAN NOT NULL DEFAULT true,
    "canManageSettings" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "care_group_members_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "daily_check_ins" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "date" DATE NOT NULL,
    "moodScore" SMALLINT,
    "energyLevel" SMALLINT,
    "sleepQuality" SMALLINT,
    "painLevel" SMALLINT,
    "stressLevel" SMALLINT,
    "symptoms" TEXT[],
    "notes" TEXT,
    "aiInsights" TEXT,
    "riskScore" DOUBLE PRECISION,
    "completed" BOOLEAN NOT NULL DEFAULT false,
    "completedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "daily_check_ins_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notifications" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "type" "NotificationType" NOT NULL,
    "channel" "NotificationChannel"[],
    "sentAt" TIMESTAMP(3),
    "readAt" TIMESTAMP(3),
    "actionUrl" TEXT,
    "priority" "NotificationPriority" NOT NULL DEFAULT 'NORMAL',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "notifications_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "documents" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "fileName" TEXT NOT NULL,
    "fileUrl" TEXT NOT NULL,
    "fileType" TEXT NOT NULL,
    "fileSize" INTEGER NOT NULL,
    "title" TEXT,
    "description" TEXT,
    "category" "DocumentCategory",
    "tags" TEXT[],
    "extractedText" TEXT,
    "aiSummary" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "documents_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "care_groups_inviteCode_key" ON "care_groups"("inviteCode");

-- CreateIndex
CREATE UNIQUE INDEX "care_group_members_careGroupId_userId_key" ON "care_group_members"("careGroupId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "daily_check_ins_userId_date_key" ON "daily_check_ins"("userId", "date");

-- AddForeignKey
ALTER TABLE "health_records" ADD CONSTRAINT "health_records_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "prescriptions" ADD CONSTRAINT "prescriptions_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reminders" ADD CONSTRAINT "reminders_prescriptionId_fkey" FOREIGN KEY ("prescriptionId") REFERENCES "prescriptions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "care_group_members" ADD CONSTRAINT "care_group_members_careGroupId_fkey" FOREIGN KEY ("careGroupId") REFERENCES "care_groups"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "care_group_members" ADD CONSTRAINT "care_group_members_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "daily_check_ins" ADD CONSTRAINT "daily_check_ins_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "documents" ADD CONSTRAINT "documents_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
