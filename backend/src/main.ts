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

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Enable CORS for web and mobile development
  app.enableCors({
    origin: [
      'http://localhost:3000',
      // Allow mobile development from any local network IP
      /^http:\/\/192\.168\.\d+\.\d+:\d+$/,
      /^http:\/\/10\.\d+\.\d+\.\d+:\d+$/,
      /^http:\/\/172\.(1[6-9]|2\d|3[01])\.\d+\.\d+:\d+$/,
    ],
    credentials: true,
  });

  // Global validation pipe
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );

  // API prefix
  app.setGlobalPrefix(process.env.API_PREFIX || 'api/v1');

  const port = process.env.PORT || 3000;
  await app.listen(port);

  const localIP = getLocalIPAddress();
  const apiPrefix = process.env.API_PREFIX || 'api/v1';

  console.log('🚀 CareCircle Backend is running:');
  console.log(`   Local:    http://localhost:${port}/${apiPrefix}`);
  console.log(`   Network:  http://${localIP}:${port}/${apiPrefix}`);
  console.log('');
  console.log(
    '📱 For mobile development, use the Network URL in your mobile app configuration',
  );
  console.log(`   Mobile API Base URL: http://${localIP}:${port}/${apiPrefix}`);
}
void bootstrap();
