/*
  Warnings:

  - Added the required column `day` to the `health_records` table without a default value. This is not possible if the table is not empty.
  - Added the required column `month` to the `health_records` table without a default value. This is not possible if the table is not empty.
  - Added the required column `year` to the `health_records` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "DataQuality" AS ENUM ('POOR', 'FAIR', 'GOOD', 'EXCELLENT');

-- CreateEnum
CREATE TYPE "SyncStatus" AS ENUM ('PENDING', 'IN_PROGRESS', 'COMPLETED', 'FAILED', 'PARTIAL');

-- CreateEnum
CREATE TYPE "ConsentType" AS ENUM ('DATA_COLLECTION', 'DATA_SHARING', 'FAMILY_SHARING', 'ANALYTICS', 'MARKETING', 'RESEARCH');

-- AlterEnum
-- This migration adds more than one value to an enum.
-- With PostgreSQL versions 11 and earlier, this is not possible
-- in a single migration. This can be worked around by creating
-- multiple migrations, each migration adding only one value to
-- the enum.


ALTER TYPE "DataSource" ADD VALUE 'IMPORTED_CSV';
ALTER TYPE "DataSource" ADD VALUE 'API_INTEGRATION';

-- AlterEnum
-- This migration adds more than one value to an enum.
-- With PostgreSQL versions 11 and earlier, this is not possible
-- in a single migration. This can be worked around by creating
-- multiple migrations, each migration adding only one value to
-- the enum.


ALTER TYPE "HealthDataType" ADD VALUE 'DISTANCE';
ALTER TYPE "HealthDataType" ADD VALUE 'ACTIVE_MINUTES';
ALTER TYPE "HealthDataType" ADD VALUE 'RESTING_HEART_RATE';
ALTER TYPE "HealthDataType" ADD VALUE 'MAX_HEART_RATE';
ALTER TYPE "HealthDataType" ADD VALUE 'DEEP_SLEEP';
ALTER TYPE "HealthDataType" ADD VALUE 'REM_SLEEP';
ALTER TYPE "HealthDataType" ADD VALUE 'SLEEP_SCORE';
ALTER TYPE "HealthDataType" ADD VALUE 'BODY_FAT';
ALTER TYPE "HealthDataType" ADD VALUE 'MUSCLE_MASS';
ALTER TYPE "HealthDataType" ADD VALUE 'INSULIN_LEVEL';
ALTER TYPE "HealthDataType" ADD VALUE 'CHOLESTEROL_TOTAL';
ALTER TYPE "HealthDataType" ADD VALUE 'CHOLESTEROL_LDL';
ALTER TYPE "HealthDataType" ADD VALUE 'CHOLESTEROL_HDL';

-- AlterTable
-- First add the columns with temporary default values
ALTER TABLE "health_records" ADD COLUMN     "day" INTEGER;
ALTER TABLE "health_records" ADD COLUMN     "month" INTEGER;
ALTER TABLE "health_records" ADD COLUMN     "year" INTEGER;

-- Update existing rows with values extracted from recordedAt
UPDATE "health_records" SET 
  "year" = EXTRACT(YEAR FROM "recordedAt"),
  "month" = EXTRACT(MONTH FROM "recordedAt"),
  "day" = EXTRACT(DAY FROM "recordedAt");

-- Now make the columns NOT NULL
ALTER TABLE "health_records" ALTER COLUMN "day" SET NOT NULL;
ALTER TABLE "health_records" ALTER COLUMN "month" SET NOT NULL;
ALTER TABLE "health_records" ALTER COLUMN "year" SET NOT NULL;

-- CreateTable
CREATE TABLE "health_metrics" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "date" DATE NOT NULL,
    "steps" INTEGER,
    "distance" DOUBLE PRECISION,
    "caloriesBurned" INTEGER,
    "activeMinutes" INTEGER,
    "exerciseMinutes" INTEGER,
    "heartRateResting" INTEGER,
    "heartRateMax" INTEGER,
    "heartRateAvg" INTEGER,
    "bloodPressureSys" INTEGER,
    "bloodPressureDia" INTEGER,
    "oxygenSaturation" DOUBLE PRECISION,
    "bodyTemperature" DOUBLE PRECISION,
    "sleepDuration" INTEGER,
    "deepSleepDuration" INTEGER,
    "remSleepDuration" INTEGER,
    "sleepScore" INTEGER,
    "bedTime" TIMESTAMP(3),
    "wakeTime" TIMESTAMP(3),
    "weight" DOUBLE PRECISION,
    "height" DOUBLE PRECISION,
    "bmi" DOUBLE PRECISION,
    "bodyFat" DOUBLE PRECISION,
    "muscleMass" DOUBLE PRECISION,
    "bloodGlucose" DOUBLE PRECISION,
    "insulinLevel" DOUBLE PRECISION,
    "cholesterolTotal" DOUBLE PRECISION,
    "cholesterolLDL" DOUBLE PRECISION,
    "cholesterolHDL" DOUBLE PRECISION,
    "lastSyncAt" TIMESTAMP(3),
    "syncSource" "DataSource" NOT NULL,
    "dataQuality" "DataQuality" NOT NULL DEFAULT 'GOOD',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "health_metrics_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "health_data_sync" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "source" "DataSource" NOT NULL,
    "lastSyncAt" TIMESTAMP(3) NOT NULL,
    "syncStatus" "SyncStatus" NOT NULL,
    "recordsCount" INTEGER NOT NULL DEFAULT 0,
    "errorMessage" TEXT,
    "syncFromDate" TIMESTAMP(3) NOT NULL,
    "syncToDate" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "health_data_sync_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "health_data_consent" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "consentType" "ConsentType" NOT NULL,
    "dataCategories" TEXT[],
    "purpose" TEXT NOT NULL,
    "consentGranted" BOOLEAN NOT NULL,
    "consentDate" TIMESTAMP(3) NOT NULL,
    "revokedAt" TIMESTAMP(3),
    "consentVersion" TEXT NOT NULL,
    "legalBasis" TEXT NOT NULL,
    "retentionPeriod" INTEGER,
    "careGroupId" TEXT,
    "shareWithFamily" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "health_data_consent_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "health_metrics_userId_date_idx" ON "health_metrics"("userId", "date");

-- CreateIndex
CREATE UNIQUE INDEX "health_metrics_userId_date_key" ON "health_metrics"("userId", "date");

-- CreateIndex
CREATE INDEX "health_data_sync_userId_source_idx" ON "health_data_sync"("userId", "source");

-- CreateIndex
CREATE INDEX "health_data_consent_userId_consentType_idx" ON "health_data_consent"("userId", "consentType");

-- CreateIndex
CREATE INDEX "health_records_userId_dataType_recordedAt_idx" ON "health_records"("userId", "dataType", "recordedAt");

-- CreateIndex
CREATE INDEX "health_records_userId_year_month_idx" ON "health_records"("userId", "year", "month");

-- CreateIndex
CREATE INDEX "health_records_recordedAt_idx" ON "health_records"("recordedAt");

-- AddForeignKey
ALTER TABLE "health_metrics" ADD CONSTRAINT "health_metrics_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "health_data_sync" ADD CONSTRAINT "health_data_sync_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "health_data_consent" ADD CONSTRAINT "health_data_consent_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
