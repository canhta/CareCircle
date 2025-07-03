-- AlterTable
ALTER TABLE "users" ADD COLUMN     "analyticsConsent" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "consentDate" TIMESTAMP(3),
ADD COLUMN     "consentVersion" TEXT,
ADD COLUMN     "dataProcessingConsent" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "healthDataSharingConsent" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "marketingConsent" BOOLEAN NOT NULL DEFAULT false;
