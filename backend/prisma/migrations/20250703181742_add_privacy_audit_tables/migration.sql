-- CreateTable
CREATE TABLE "health_data_access" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "action" TEXT NOT NULL,
    "accessor" TEXT NOT NULL,
    "dataType" TEXT,
    "accessedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "ipAddress" TEXT,
    "userAgent" TEXT,
    "metadata" TEXT,

    CONSTRAINT "health_data_access_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "data_export_request" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "exportType" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "requestedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "completedAt" TIMESTAMP(3),
    "downloadUrl" TEXT,
    "expiresAt" TIMESTAMP(3),
    "fileSize" BIGINT,
    "recordsCount" INTEGER,
    "errorMessage" TEXT,

    CONSTRAINT "data_export_request_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "data_deletion_request" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "requestedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "scheduledDeletionDate" TIMESTAMP(3) NOT NULL,
    "completedAt" TIMESTAMP(3),
    "cancelledAt" TIMESTAMP(3),
    "legalBasis" TEXT,
    "retentionNote" TEXT,

    CONSTRAINT "data_deletion_request_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "health_data_access_userId_accessedAt_idx" ON "health_data_access"("userId", "accessedAt");

-- CreateIndex
CREATE INDEX "data_export_request_userId_requestedAt_idx" ON "data_export_request"("userId", "requestedAt");

-- CreateIndex
CREATE INDEX "data_deletion_request_userId_requestedAt_idx" ON "data_deletion_request"("userId", "requestedAt");

-- AddForeignKey
ALTER TABLE "health_data_access" ADD CONSTRAINT "health_data_access_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "data_export_request" ADD CONSTRAINT "data_export_request_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "data_deletion_request" ADD CONSTRAINT "data_deletion_request_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
