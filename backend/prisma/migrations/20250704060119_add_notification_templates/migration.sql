/*
  Warnings:

  - The values [LAB_RESULT,MEDICAL_REPORT,EMERGENCY_CONTACT] on the enum `DocumentCategory` will be removed. If these variants are still used in the database, this will fail.
  - You are about to drop the `data_deletion_request` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `data_export_request` table. If the table is not empty, all the data it contains will be lost.

*/
-- AlterEnum
BEGIN;
CREATE TYPE "DocumentCategory_new" AS ENUM ('PRESCRIPTION', 'MEDICAL_RECORD', 'INSURANCE', 'REPORT', 'OTHER');
ALTER TABLE "documents" ALTER COLUMN "category" TYPE "DocumentCategory_new" USING ("category"::text::"DocumentCategory_new");
ALTER TYPE "DocumentCategory" RENAME TO "DocumentCategory_old";
ALTER TYPE "DocumentCategory_new" RENAME TO "DocumentCategory";
DROP TYPE "DocumentCategory_old";
COMMIT;

-- DropForeignKey
ALTER TABLE "data_deletion_request" DROP CONSTRAINT "data_deletion_request_userId_fkey";

-- DropForeignKey
ALTER TABLE "data_export_request" DROP CONSTRAINT "data_export_request_userId_fkey";

-- DropTable
DROP TABLE "data_deletion_request";

-- DropTable
DROP TABLE "data_export_request";

-- CreateTable
CREATE TABLE "data_export_requests" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "requestedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "completedAt" TIMESTAMP(3),
    "downloadUrl" TEXT,
    "expiresAt" TIMESTAMP(3),
    "exportType" TEXT NOT NULL DEFAULT 'FULL_DATA',
    "status" TEXT NOT NULL DEFAULT 'PENDING',
    "fileSize" BIGINT,

    CONSTRAINT "data_export_requests_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "data_deletion_requests" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "requestedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "scheduledDeletionDate" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),
    "cancelledAt" TIMESTAMP(3),
    "status" TEXT NOT NULL DEFAULT 'PENDING',
    "reason" TEXT,

    CONSTRAINT "data_deletion_requests_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notification_templates" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "type" "NotificationType" NOT NULL,
    "titleTemplate" TEXT NOT NULL,
    "messageTemplate" TEXT NOT NULL,
    "placeholders" JSONB NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "version" INTEGER NOT NULL DEFAULT 1,
    "channels" "NotificationChannel"[],
    "defaultPriority" "NotificationPriority" NOT NULL DEFAULT 'NORMAL',
    "language" TEXT NOT NULL DEFAULT 'en',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "notification_templates_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "data_export_requests_userId_requestedAt_idx" ON "data_export_requests"("userId", "requestedAt");

-- CreateIndex
CREATE INDEX "data_deletion_requests_userId_requestedAt_idx" ON "data_deletion_requests"("userId", "requestedAt");

-- CreateIndex
CREATE UNIQUE INDEX "notification_templates_name_key" ON "notification_templates"("name");

-- AddForeignKey
ALTER TABLE "data_export_requests" ADD CONSTRAINT "data_export_requests_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "data_deletion_requests" ADD CONSTRAINT "data_deletion_requests_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
