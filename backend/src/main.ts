import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { AppModule } from './app.module';
import * as os from 'os';

function getLocalIPAddress(): string {
  const interfaces = os.networkInterfaces();
  for (const name of Object.keys(interfaces)) {
    for (const iface of interfaces[name] || []) {
      // Skip over non-IPv4 and internal (i.e. 127.0.0.1) addresses
      if (iface.family === 'IPv4' && !iface.internal) {
        return iface.address;
      }
    }
  }
  return 'localhost';
}

function getProductionCorsOrigins(): boolean | (string | RegExp)[] {
  const origins: (string | RegExp)[] = [];

  // Custom production domains from environment
  if (process.env.ALLOWED_ORIGINS) {
    const customOrigins = process.env.ALLOWED_ORIGINS.split(',');
    origins.push(...customOrigins);
  }

  // Development origins (only in non-production)
  if (process.env.NODE_ENV !== 'production') {
    origins.push('http://localhost:3000');
    origins.push(/^http:\/\/192\.168\.\d+\.\d+:\d+$/);
    origins.push(/^http:\/\/10\.\d+\.\d+\.\d+:\d+$/);
    origins.push(/^http:\/\/172\.(1[6-9]|2\d|3[01])\.\d+\.\d+:\d+$/);
  }

  // If no custom origins specified, allow all origins in production for now
  // This can be restricted later when domains are available
  if (origins.length === 0) {
    return true; // Allow all origins
  }

  return origins;
}

async function bootstrap() {
  const app = await NestFactory.create(AppModule, {
    logger:
      process.env.NODE_ENV === 'production'
        ? ['error', 'warn', 'log']
        : ['error', 'warn', 'log', 'debug', 'verbose'],
  });

  // Production-ready CORS configuration
  app.enableCors({
    origin: getProductionCorsOrigins(),
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
    allowedHeaders: [
      'Origin',
      'X-Requested-With',
      'Content-Type',
      'Accept',
      'Authorization',
      'X-API-Key',
    ],
    exposedHeaders: ['X-Total-Count', 'X-Page-Count'],
    maxAge: 86400, // 24 hours
  });

  // Global validation pipe with production settings
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
      disableErrorMessages: process.env.NODE_ENV === 'production',
      validationError: {
        target: false,
        value: false,
      },
    }),
  );

  // API prefix
  const apiPrefix = process.env.API_PREFIX || 'api/v1';
  app.setGlobalPrefix(apiPrefix);

  // Use PORT environment variable (required by Cloud Run)
  const port = process.env.PORT || 8080;

  // Listen on all interfaces (required for Cloud Run)
  await app.listen(port, '0.0.0.0');

  const localIP = getLocalIPAddress();
  const isProduction = process.env.NODE_ENV === 'production';

  console.log('🚀 CareCircle Backend is running:');

  if (isProduction) {
    // In production (Cloud Run), log the service information
    console.log(`   Environment: ${process.env.NODE_ENV}`);
    console.log(`   Port: ${port}`);
    console.log(`   API Prefix: ${apiPrefix}`);
  } else {
    // Development logging
    console.log(`   Local:    http://localhost:${port}/${apiPrefix}`);
    console.log(`   Network:  http://${localIP}:${port}/${apiPrefix}`);
  }
}

// Graceful shutdown handling
process.on('SIGTERM', () => {
  console.log('🛑 SIGTERM received, shutting down gracefully...');
  process.exit(0);
});

process.on('SIGINT', () => {
  console.log('🛑 SIGINT received, shutting down gracefully...');
  process.exit(0);
});

void bootstrap();
