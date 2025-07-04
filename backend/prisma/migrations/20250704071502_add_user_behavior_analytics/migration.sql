-- CreateTable
CREATE TABLE "user_notification_behaviors" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "notificationId" TEXT NOT NULL,
    "action" TEXT NOT NULL,
    "timestamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "timeToAction" INTEGER,
    "deviceType" TEXT,
    "timeOfDay" INTEGER NOT NULL,
    "dayOfWeek" INTEGER NOT NULL,
    "notificationType" TEXT NOT NULL,
    "contextData" JSONB,

    CONSTRAINT "user_notification_behaviors_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_engagement_patterns" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "preferredTimes" JSONB NOT NULL,
    "responseRate" DOUBLE PRECISION NOT NULL,
    "averageResponseTime" DOUBLE PRECISION NOT NULL,
    "bestNotificationTypes" JSONB NOT NULL,
    "worstNotificationTypes" JSONB NOT NULL,
    "engagementTrend" TEXT NOT NULL,
    "lastAnalysisDate" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "insights" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_engagement_patterns_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_behavior_vectors" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "vectorData" JSONB NOT NULL,
    "lastUpdated" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "user_behavior_vectors_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "user_engagement_patterns_userId_key" ON "user_engagement_patterns"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "user_behavior_vectors_userId_key" ON "user_behavior_vectors"("userId");

-- AddForeignKey
ALTER TABLE "user_notification_behaviors" ADD CONSTRAINT "user_notification_behaviors_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_notification_behaviors" ADD CONSTRAINT "user_notification_behaviors_notificationId_fkey" FOREIGN KEY ("notificationId") REFERENCES "notifications"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_engagement_patterns" ADD CONSTRAINT "user_engagement_patterns_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_behavior_vectors" ADD CONSTRAINT "user_behavior_vectors_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
