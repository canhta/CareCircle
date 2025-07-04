import { NestFactory } from '@nestjs/core';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Swagger configuration
  const config = new DocumentBuilder()
    .setTitle('CareCircle API')
    .setDescription(
      'The CareCircle API provides comprehensive healthcare management features including health records, care groups, notifications, and analytics.',
    )
    .setVersion('1.0')
    .addTag('auth', 'Authentication endpoints')
    .addTag('users', 'User management')
    .addTag('health-records', 'Health record management')
    .addTag('care-groups', 'Care group management')
    .addTag('notifications', 'Notification system')
    .addTag('prescriptions', 'Prescription management')
    .addTag('daily-check-ins', 'Daily check-in tracking')
    .addTag('alerts', 'Alert system')
    .addTag('analytics', 'Analytics and insights')
    .addTag('recommendations', 'AI-powered recommendations')
    .addTag('subscriptions', 'Subscription management')
    .addBearerAuth(
      {
        type: 'http',
        scheme: 'bearer',
        bearerFormat: 'JWT',
        name: 'JWT',
        description: 'Enter JWT token',
        in: 'header',
      },
      'JWT-auth',
    )
    .build();

  const documentFactory = () => SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, documentFactory, {
    swaggerOptions: {
      persistAuthorization: true,
    },
  });

  await app.listen(process.env.PORT ?? 3000);
}

void bootstrap();
