// Configuration utility for the CareCircle Admin Portal

export interface AppConfig {
  app: {
    name: string;
    version: string;
    environment: string;
  };
  api: {
    baseUrl: string;
    timeout: number;
  };
  auth: {
    nextAuthUrl: string;
  };
  monitoring: {
    sentryDsn?: string;
    googleAnalyticsId?: string;
  };
}

const config: AppConfig = {
  app: {
    name: process.env.NEXT_PUBLIC_APP_NAME || 'CareCircle Admin Portal',
    version: process.env.NEXT_PUBLIC_APP_VERSION || '1.0.0',
    environment: process.env.NEXT_PUBLIC_ENVIRONMENT || 'development',
  },
  api: {
    baseUrl: process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3000',
    timeout: 30000,
  },
  auth: {
    nextAuthUrl: process.env.NEXTAUTH_URL || 'http://localhost:3030',
  },
  monitoring: {
    sentryDsn: process.env.NEXT_PUBLIC_SENTRY_DSN,
    googleAnalyticsId: process.env.NEXT_PUBLIC_GOOGLE_ANALYTICS_ID,
  },
};

// Server-side only configuration (not exposed to client)
export const serverConfig = {
  database: {
    url: process.env.DATABASE_URL,
  },
  auth: {
    secret: process.env.NEXTAUTH_SECRET,
  },
  api: {
    secretKey: process.env.API_SECRET_KEY,
  },
};

// Validation function to check required environment variables
export function validateConfig(): { isValid: boolean; errors: string[] } {
  const errors: string[] = [];

  // Check required public variables
  if (!config.api.baseUrl) {
    errors.push('NEXT_PUBLIC_API_URL is required');
  }

  // Check required server-side variables (only on server)
  if (typeof window === 'undefined') {
    if (!serverConfig.auth.secret) {
      errors.push('NEXTAUTH_SECRET is required');
    }
  }

  return {
    isValid: errors.length === 0,
    errors,
  };
}

// Helper function to check if we're in development mode
export const isDevelopment = config.app.environment === 'development';
export const isProduction = config.app.environment === 'production';

export default config;
