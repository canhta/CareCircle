-- CreateTable
CREATE TABLE "hipaa_audit_logs" (
    "id" TEXT NOT NULL,
    "eventType" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "agentType" TEXT,
    "queryHash" TEXT NOT NULL,
    "responseHash" TEXT NOT NULL,
    "severity" TEXT NOT NULL,
    "containsPHI" BOOLEAN NOT NULL DEFAULT false,
    "emergencyFlag" BOOLEAN NOT NULL DEFAULT false,
    "complianceFlags" TEXT[],
    "sessionId" TEXT,
    "ipAddress" TEXT,
    "userAgent" TEXT,
    "processingTimeMs" INTEGER NOT NULL,
    "confidence" DOUBLE PRECISION,
    "escalationReason" TEXT,
    "vietnameseLanguage" BOOLEAN DEFAULT false,
    "timestamp" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "hipaa_audit_logs_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "hipaa_audit_logs_userId_timestamp_idx" ON "hipaa_audit_logs"("userId", "timestamp");

-- CreateIndex
CREATE INDEX "hipaa_audit_logs_eventType_timestamp_idx" ON "hipaa_audit_logs"("eventType", "timestamp");

-- CreateIndex
CREATE INDEX "hipaa_audit_logs_severity_emergencyFlag_idx" ON "hipaa_audit_logs"("severity", "emergencyFlag");

-- CreateIndex
CREATE INDEX "hipaa_audit_logs_containsPHI_timestamp_idx" ON "hipaa_audit_logs"("containsPHI", "timestamp");

-- CreateIndex
CREATE INDEX "hipaa_audit_logs_createdAt_idx" ON "hipaa_audit_logs"("createdAt");

-- AddForeignKey
ALTER TABLE "hipaa_audit_logs" ADD CONSTRAINT "hipaa_audit_logs_userId_fkey" FOREIGN KEY ("userId") REFERENCES "user_accounts"("id") ON DELETE CASCADE ON UPDATE CASCADE;
