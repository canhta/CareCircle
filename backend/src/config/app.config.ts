export interface DatabaseConfig {
  url?: string;
  host: string;
  port: number;
  username: string;
  password: string;
  name: string;
}

export interface JwtConfig {
  secret: string;
  expiresIn: string;
  refreshExpiresIn: string;
}

export interface RedisConfig {
  url?: string;
  host: string;
  port: number;
}

export interface ExternalApiConfig {
  appleHealthKitKey?: string;
  googleFitClientId?: string;
  googleFitClientSecret?: string;
  openaiApiKey?: string;
  openaiModel: string;
  googleVisionApiKey?: string;
}

export interface AppConfig {
  port: number;
  nodeEnv: string;
  database: DatabaseConfig;
  jwt: JwtConfig;
  redis: RedisConfig;
  externalApis: ExternalApiConfig;
}

export default (): AppConfig => ({
  port: parseInt(process.env.PORT || '3000', 10),
  nodeEnv: process.env.NODE_ENV || 'development',
  database: {
    url: process.env.DATABASE_URL,
    host: process.env.DATABASE_HOST || 'localhost',
    port: parseInt(process.env.DATABASE_PORT || '5432', 10),
    username: process.env.DATABASE_USERNAME || 'postgres',
    password: process.env.DATABASE_PASSWORD || 'password',
    name: process.env.DATABASE_NAME || 'carecircle',
  },
  jwt: {
    secret: process.env.JWT_SECRET || 'default-secret-change-in-production',
    expiresIn: process.env.JWT_EXPIRES_IN || '24h',
    refreshExpiresIn: process.env.JWT_REFRESH_EXPIRES_IN || '7d',
  },
  redis: {
    url: process.env.REDIS_URL,
    host: process.env.REDIS_HOST || 'localhost',
    port: parseInt(process.env.REDIS_PORT || '6379', 10),
  },
  externalApis: {
    appleHealthKitKey: process.env.APPLE_HEALTHKIT_KEY,
    googleFitClientId: process.env.GOOGLE_FIT_CLIENT_ID,
    googleFitClientSecret: process.env.GOOGLE_FIT_CLIENT_SECRET,
    openaiApiKey: process.env.OPENAI_API_KEY,
    openaiModel: process.env.OPENAI_MODEL || 'gpt-4',
    googleVisionApiKey: process.env.GOOGLE_VISION_API_KEY,
  },
});
