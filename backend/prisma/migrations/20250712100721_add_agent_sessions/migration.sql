-- CreateEnum
CREATE TYPE "AgentSessionType" AS ENUM ('CONSULTATION', 'MEDICATION', 'EMERGENCY', 'WELLNESS', 'VIETNAMESE_HEALTHCARE');

-- CreateEnum
CREATE TYPE "AgentSessionStatus" AS ENUM ('ACTIVE', 'COMPLETED', 'ESCALATED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "AgentType" AS ENUM ('SUPERVISOR', 'MEDICATION', 'EMERGENCY', 'CLINICAL', 'VIETNAMESE_MEDICAL', 'HEALTH_ANALYTICS');

-- CreateEnum
CREATE TYPE "AgentInteractionType" AS ENUM ('QUERY', 'HANDOFF', 'ESCALATION', 'ANALYSIS', 'RECOMMENDATION');

-- CreateEnum
CREATE TYPE "UrgencyLevel" AS ENUM ('ROUTINE', 'URGENT', 'EMERGENCY');

-- CreateTable
CREATE TABLE "agent_sessions" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "patientId" TEXT,
    "sessionType" "AgentSessionType" NOT NULL,
    "status" "AgentSessionStatus" NOT NULL DEFAULT 'ACTIVE',
    "metadata" JSONB NOT NULL DEFAULT '{}',
    "healthcareContext" JSONB NOT NULL DEFAULT '{}',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "agent_sessions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "agent_interactions" (
    "id" TEXT NOT NULL,
    "sessionId" TEXT NOT NULL,
    "agentType" "AgentType" NOT NULL,
    "interactionType" "AgentInteractionType" NOT NULL,
    "userQuery" TEXT NOT NULL,
    "agentResponse" TEXT NOT NULL,
    "urgencyLevel" "UrgencyLevel" NOT NULL DEFAULT 'ROUTINE',
    "metadata" JSONB NOT NULL DEFAULT '{}',
    "queryHash" TEXT NOT NULL,
    "responseHash" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "agent_interactions_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "agent_interactions_sessionId_idx" ON "agent_interactions"("sessionId");

-- CreateIndex
CREATE INDEX "agent_interactions_agentType_idx" ON "agent_interactions"("agentType");

-- CreateIndex
CREATE INDEX "agent_interactions_urgencyLevel_idx" ON "agent_interactions"("urgencyLevel");

-- CreateIndex
CREATE INDEX "agent_interactions_createdAt_idx" ON "agent_interactions"("createdAt");

-- AddForeignKey
ALTER TABLE "agent_sessions" ADD CONSTRAINT "agent_sessions_userId_fkey" FOREIGN KEY ("userId") REFERENCES "user_accounts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "agent_interactions" ADD CONSTRAINT "agent_interactions_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "agent_sessions"("id") ON DELETE CASCADE ON UPDATE CASCADE;
