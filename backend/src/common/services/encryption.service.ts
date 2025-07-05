import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as crypto from 'crypto';
import * as bcrypt from 'bcrypt';

@Injectable()
export class EncryptionService {
  private readonly logger = new Logger(EncryptionService.name);
  private readonly algorithm = 'aes-256-gcm';
  private readonly keyLength = 32;
  private readonly ivLength = 16;
  private readonly tagLength = 16;
  private readonly saltRounds = 12;

  constructor(private readonly configService: ConfigService) {}

  /**
   * Encrypt sensitive data using AES-256-GCM
   */
  encrypt(
    plaintext: string,
    key?: string,
  ): { encrypted: string; iv: string; tag: string } {
    try {
      const encryptionKey = key ? this.deriveKey(key) : this.getDefaultKey();
      const iv = crypto.randomBytes(this.ivLength);

      const cipher = crypto.createCipheriv(this.algorithm, encryptionKey, iv);
      cipher.setAAD(Buffer.from('CareCircle-PHI', 'utf8'));

      let encrypted = cipher.update(plaintext, 'utf8', 'hex');
      encrypted += cipher.final('hex');

      const tag = cipher.getAuthTag();

      return {
        encrypted,
        iv: iv.toString('hex'),
        tag: tag.toString('hex'),
      };
    } catch (error) {
      this.logger.error('Encryption failed', error.stack);
      throw new Error('Failed to encrypt data');
    }
  }

  /**
   * Decrypt sensitive data using AES-256-GCM
   */
  decrypt(
    encryptedData: { encrypted: string; iv: string; tag: string },
    key?: string,
  ): string {
    try {
      const encryptionKey = key ? this.deriveKey(key) : this.getDefaultKey();
      const iv = Buffer.from(encryptedData.iv, 'hex');
      const tag = Buffer.from(encryptedData.tag, 'hex');

      const decipher = crypto.createDecipheriv(
        this.algorithm,
        encryptionKey,
        iv,
      );
      decipher.setAAD(Buffer.from('CareCircle-PHI', 'utf8'));
      decipher.setAuthTag(tag);

      let decrypted = decipher.update(encryptedData.encrypted, 'hex', 'utf8');
      decrypted += decipher.final('utf8');

      return decrypted;
    } catch (error) {
      this.logger.error('Decryption failed', error.stack);
      throw new Error('Failed to decrypt data');
    }
  }

  /**
   * Hash passwords using bcrypt
   */
  async hashPassword(password: string): Promise<string> {
    try {
      return await bcrypt.hash(password, this.saltRounds);
    } catch (error) {
      this.logger.error('Password hashing failed', error.stack);
      throw new Error('Failed to hash password');
    }
  }

  /**
   * Verify password against hash
   */
  async verifyPassword(password: string, hash: string): Promise<boolean> {
    try {
      return await bcrypt.compare(password, hash);
    } catch (error) {
      this.logger.error('Password verification failed', error.stack);
      return false;
    }
  }

  /**
   * Generate a secure random token
   */
  generateSecureToken(length: number = 32): string {
    return crypto.randomBytes(length).toString('hex');
  }

  /**
   * Generate a cryptographically secure random string
   */
  generateSecureString(length: number = 16): string {
    const chars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    let result = '';

    for (let i = 0; i < length; i++) {
      const randomIndex = crypto.randomInt(0, chars.length);
      result += chars[randomIndex];
    }

    return result;
  }

  /**
   * Create HMAC signature
   */
  createHMAC(data: string, secret?: string): string {
    const key = secret || this.getHMACKey();
    return crypto.createHmac('sha256', key).update(data).digest('hex');
  }

  /**
   * Verify HMAC signature
   */
  verifyHMAC(data: string, signature: string, secret?: string): boolean {
    const expectedSignature = this.createHMAC(data, secret);
    return crypto.timingSafeEqual(
      Buffer.from(signature, 'hex'),
      Buffer.from(expectedSignature, 'hex'),
    );
  }

  /**
   * Encrypt PHI data with additional metadata
   */
  encryptPHI(data: any, userId: string): string {
    const plaintext = JSON.stringify({
      data,
      userId,
      timestamp: new Date().toISOString(),
    });

    const encrypted = this.encrypt(plaintext);
    return Buffer.from(JSON.stringify(encrypted)).toString('base64');
  }

  /**
   * Decrypt PHI data and verify metadata
   */
  decryptPHI(encryptedData: string, expectedUserId?: string): any {
    try {
      const encrypted = JSON.parse(
        Buffer.from(encryptedData, 'base64').toString(),
      );
      const decrypted = this.decrypt(encrypted);
      const parsed = JSON.parse(decrypted);

      if (expectedUserId && parsed.userId !== expectedUserId) {
        throw new Error('User ID mismatch in encrypted PHI data');
      }

      return parsed.data;
    } catch (error) {
      this.logger.error('PHI decryption failed', error.stack);
      throw new Error('Failed to decrypt PHI data');
    }
  }

  private getDefaultKey(): Buffer {
    const key = this.configService.get<string>('ENCRYPTION_KEY');
    if (!key) {
      throw new Error('Encryption key not configured');
    }
    return this.deriveKey(key);
  }

  private getHMACKey(): string {
    const key = this.configService.get<string>('HMAC_KEY');
    if (!key) {
      throw new Error('HMAC key not configured');
    }
    return key;
  }

  private deriveKey(password: string): Buffer {
    const salt =
      this.configService.get<string>('ENCRYPTION_SALT') || 'CareCircle-Salt';
    return crypto.pbkdf2Sync(password, salt, 100000, this.keyLength, 'sha256');
  }
}
