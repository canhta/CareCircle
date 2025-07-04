-- CreateEnum
CREATE TYPE "SubscriptionStatus" AS ENUM ('ACTIVE', 'EXPIRED', 'CANCELLED', 'PENDING', 'SUSPENDED');

-- CreateEnum
CREATE TYPE "PaymentMethod" AS ENUM ('CREDIT_CARD', 'APPLE_PAY', 'GOOGLE_PAY', 'MOMO', 'ZALOPAY', 'BANK_TRANSFER');

-- CreateEnum
CREATE TYPE "PaymentProvider" AS ENUM ('APPLE_APP_STORE', 'GOOGLE_PLAY_STORE', 'MOMO', 'ZALOPAY', 'STRIPE');

-- CreateEnum
CREATE TYPE "PaymentStatus" AS ENUM ('PENDING', 'COMPLETED', 'FAILED', 'REFUNDED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "ReferralRewardType" AS ENUM ('DISCOUNT_PERCENTAGE', 'DISCOUNT_FIXED', 'FREE_DAYS', 'CREDITS');

-- CreateEnum
CREATE TYPE "ReferralStatus" AS ENUM ('PENDING', 'COMPLETED', 'EXPIRED', 'CANCELLED');

-- CreateTable
CREATE TABLE "vector_interaction_metadata" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "milvusId" TEXT NOT NULL,
    "interactionType" TEXT NOT NULL,
    "checkInId" TEXT,
    "summary" TEXT,
    "category" TEXT,
    "tags" TEXT[],
    "sentiment" DOUBLE PRECISION,
    "riskScore" DOUBLE PRECISION,
    "anomalyScore" DOUBLE PRECISION,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "vector_interaction_metadata_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "subscription_plans" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "price" DOUBLE PRECISION NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'USD',
    "duration" INTEGER NOT NULL,
    "features" JSONB NOT NULL,
    "maxCareGroupSize" INTEGER,
    "maxHealthDataSync" INTEGER,
    "maxDocumentStorage" INTEGER,
    "maxNotifications" INTEGER,
    "maxAIInsights" INTEGER,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "isDefault" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "subscription_plans_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_subscriptions" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "subscriptionPlanId" TEXT NOT NULL,
    "startDate" TIMESTAMP(3) NOT NULL,
    "endDate" TIMESTAMP(3) NOT NULL,
    "status" "SubscriptionStatus" NOT NULL,
    "paymentMethod" "PaymentMethod" NOT NULL,
    "paymentReference" TEXT,
    "autoRenew" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_subscriptions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payments" (
    "id" TEXT NOT NULL,
    "userSubscriptionId" TEXT NOT NULL,
    "amount" DOUBLE PRECISION NOT NULL,
    "currency" TEXT NOT NULL,
    "paymentMethod" "PaymentMethod" NOT NULL,
    "paymentProvider" "PaymentProvider" NOT NULL,
    "providerTransactionId" TEXT,
    "providerPaymentId" TEXT,
    "status" "PaymentStatus" NOT NULL,
    "paidAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "payments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "referral_codes" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "rewardType" "ReferralRewardType" NOT NULL,
    "rewardValue" DOUBLE PRECISION NOT NULL,
    "maxUses" INTEGER NOT NULL DEFAULT 1,
    "usedCount" INTEGER NOT NULL DEFAULT 0,
    "expiresAt" TIMESTAMP(3),
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "referral_codes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "referrals" (
    "id" TEXT NOT NULL,
    "referralCodeId" TEXT NOT NULL,
    "referredUserId" TEXT NOT NULL,
    "rewardClaimed" BOOLEAN NOT NULL DEFAULT false,
    "rewardClaimedAt" TIMESTAMP(3),
    "status" "ReferralStatus" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "referrals_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "vector_interaction_metadata_milvusId_key" ON "vector_interaction_metadata"("milvusId");

-- CreateIndex
CREATE INDEX "vector_interaction_metadata_userId_interactionType_idx" ON "vector_interaction_metadata"("userId", "interactionType");

-- CreateIndex
CREATE INDEX "vector_interaction_metadata_userId_createdAt_idx" ON "vector_interaction_metadata"("userId", "createdAt");

-- CreateIndex
CREATE INDEX "user_subscriptions_userId_status_idx" ON "user_subscriptions"("userId", "status");

-- CreateIndex
CREATE INDEX "user_subscriptions_endDate_idx" ON "user_subscriptions"("endDate");

-- CreateIndex
CREATE INDEX "payments_userSubscriptionId_idx" ON "payments"("userSubscriptionId");

-- CreateIndex
CREATE INDEX "payments_status_idx" ON "payments"("status");

-- CreateIndex
CREATE UNIQUE INDEX "referral_codes_code_key" ON "referral_codes"("code");

-- CreateIndex
CREATE INDEX "referral_codes_userId_idx" ON "referral_codes"("userId");

-- CreateIndex
CREATE INDEX "referral_codes_code_idx" ON "referral_codes"("code");

-- CreateIndex
CREATE INDEX "referrals_referralCodeId_idx" ON "referrals"("referralCodeId");

-- CreateIndex
CREATE INDEX "referrals_referredUserId_idx" ON "referrals"("referredUserId");

-- CreateIndex
CREATE UNIQUE INDEX "referrals_referralCodeId_referredUserId_key" ON "referrals"("referralCodeId", "referredUserId");

-- AddForeignKey
ALTER TABLE "vector_interaction_metadata" ADD CONSTRAINT "vector_interaction_metadata_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "vector_interaction_metadata" ADD CONSTRAINT "vector_interaction_metadata_checkInId_fkey" FOREIGN KEY ("checkInId") REFERENCES "daily_check_ins"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_subscriptions" ADD CONSTRAINT "user_subscriptions_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_subscriptions" ADD CONSTRAINT "user_subscriptions_subscriptionPlanId_fkey" FOREIGN KEY ("subscriptionPlanId") REFERENCES "subscription_plans"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payments" ADD CONSTRAINT "payments_userSubscriptionId_fkey" FOREIGN KEY ("userSubscriptionId") REFERENCES "user_subscriptions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "referral_codes" ADD CONSTRAINT "referral_codes_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "referrals" ADD CONSTRAINT "referrals_referralCodeId_fkey" FOREIGN KEY ("referralCodeId") REFERENCES "referral_codes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "referrals" ADD CONSTRAINT "referrals_referredUserId_fkey" FOREIGN KEY ("referredUserId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
