import {
  Module,
  NestModule,
  MiddlewareConsumer,
  RequestMethod,
} from '@nestjs/common';
import { SubscriptionService } from './subscription.service';
import { SubscriptionController } from './subscription.controller';
import { PrismaModule } from '../prisma/prisma.module';
import { WebhookService } from './services/webhook.service';
import { WebhookController } from './controllers/webhook.controller';
import { ConfigModule } from '@nestjs/config';
import {
  RawBodyMiddleware,
  JsonBodyMiddleware,
} from './middlewares/raw-body.middleware';
import { SubscriptionAnalyticsService } from './services/subscription-analytics.service';
import { SubscriptionAnalyticsController } from './controllers/analytics.controller';
import { APP_GUARD } from '@nestjs/core';
import { SubscriptionFeatureGuard } from './guards/subscription-feature.guard';

@Module({
  imports: [PrismaModule, ConfigModule],
  controllers: [
    SubscriptionController,
    WebhookController,
    SubscriptionAnalyticsController,
  ],
  providers: [
    SubscriptionService,
    WebhookService,
    SubscriptionAnalyticsService,
    {
      provide: APP_GUARD,
      useClass: SubscriptionFeatureGuard,
    },
  ],
  exports: [SubscriptionService, WebhookService, SubscriptionAnalyticsService],
})
export class SubscriptionModule implements NestModule {
  public configure(consumer: MiddlewareConsumer) {
    // For endpoints that need the raw body (like webhooks with signature verification)
    consumer
      .apply(RawBodyMiddleware)
      .forRoutes(
        { path: '/webhooks/stripe', method: RequestMethod.POST },
        { path: '/webhooks/momo', method: RequestMethod.POST },
        { path: '/webhooks/zalopay', method: RequestMethod.POST },
      );

    // For all other endpoints that need JSON parsing
    consumer
      .apply(JsonBodyMiddleware)
      .forRoutes({ path: '/(.*)', method: RequestMethod.ALL });
  }
}
