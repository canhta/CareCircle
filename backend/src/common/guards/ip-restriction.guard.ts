import {
  Injectable,
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  Logger,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { ConfigService } from '@nestjs/config';
import { AuditService } from '../services/audit.service';
import { SetMetadata } from '@nestjs/common';
import { RequestIPData, IPAuditData } from '../interfaces/guards.interfaces';
import { SecurityEventType } from '../interfaces/exception.interfaces';

// Metadata key for IP restrictions
export const IP_RESTRICTION_KEY = 'ip_restriction';

export interface IPRestrictionConfig {
  allowedIPs?: string[];
  blockedIPs?: string[];
  allowedCIDRs?: string[];
  blockedCIDRs?: string[];
  mode: 'whitelist' | 'blacklist';
}

/**
 * Decorator to restrict access based on IP address
 */
export const RestrictIP = (config: IPRestrictionConfig) =>
  SetMetadata(IP_RESTRICTION_KEY, config);

/**
 * Convenience decorators for common IP restriction patterns
 */
export const AdminIPsOnly = () =>
  RestrictIP({
    mode: 'whitelist',
    allowedCIDRs: process.env.ADMIN_IP_RANGES?.split(',') || ['127.0.0.1/32'],
  });

export const BlockSuspiciousIPs = () =>
  RestrictIP({
    mode: 'blacklist',
    blockedCIDRs: process.env.BLOCKED_IP_RANGES?.split(',') || [],
  });

@Injectable()
export class IPRestrictionGuard implements CanActivate {
  private readonly logger = new Logger(IPRestrictionGuard.name);

  constructor(
    private readonly reflector: Reflector,
    private readonly configService: ConfigService,
    private readonly auditService: AuditService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const ipConfig = this.reflector.get<IPRestrictionConfig>(
      IP_RESTRICTION_KEY,
      context.getHandler(),
    );

    // If no IP restrictions configured, allow access
    if (!ipConfig) {
      return true;
    }

    const request = context.switchToHttp().getRequest<RequestIPData>();
    const clientIP = this.getClientIP(request);
    const userId = request.user?.id || request.user?.sub || 'anonymous';

    try {
      const isAllowed = this.checkIPAccess(clientIP, ipConfig);

      if (!isAllowed) {
        await this.auditIPRestriction(userId, clientIP, request, 'BLOCKED');
        throw new ForbiddenException(
          `Access denied from IP address: ${clientIP}`,
        );
      }

      // Log successful access for whitelist mode (more restrictive)
      if (ipConfig.mode === 'whitelist') {
        await this.auditIPRestriction(userId, clientIP, request, 'ALLOWED');
      }

      return true;
    } catch (error) {
      const err = error instanceof Error ? error : new Error(String(error));
      this.logger.warn(
        `IP restriction check failed for ${clientIP}: ${err.message}`,
      );
      throw error;
    }
  }

  private getClientIP(request: RequestIPData): string {
    // Check various headers for the real client IP
    const possibleHeaders = [
      'x-forwarded-for',
      'x-real-ip',
      'x-client-ip',
      'cf-connecting-ip', // Cloudflare
      'x-forwarded',
      'forwarded-for',
      'forwarded',
    ];

    for (const header of possibleHeaders) {
      const value = request.headers[header];
      if (value) {
        // x-forwarded-for can contain multiple IPs, take the first one
        const ipValue = Array.isArray(value) ? value[0] : value;
        const ip = ipValue.split(',')[0].trim();
        if (this.isValidIP(ip)) {
          return ip;
        }
      }
    }

    // Fallback to connection remote address
    return (
      request.connection?.remoteAddress ||
      request.socket?.remoteAddress ||
      request.ip ||
      'unknown'
    );
  }

  private checkIPAccess(
    clientIP: string,
    config: IPRestrictionConfig,
  ): boolean {
    if (config.mode === 'whitelist') {
      return this.isIPAllowed(clientIP, config);
    } else {
      return !this.isIPBlocked(clientIP, config);
    }
  }

  private isIPAllowed(clientIP: string, config: IPRestrictionConfig): boolean {
    // Check exact IP matches
    if (config.allowedIPs?.includes(clientIP)) {
      return true;
    }

    // Check CIDR ranges
    if (config.allowedCIDRs) {
      return config.allowedCIDRs.some((cidr) =>
        this.isIPInCIDR(clientIP, cidr),
      );
    }

    return false;
  }

  private isIPBlocked(clientIP: string, config: IPRestrictionConfig): boolean {
    // Check exact IP matches
    if (config.blockedIPs?.includes(clientIP)) {
      return true;
    }

    // Check CIDR ranges
    if (config.blockedCIDRs) {
      return config.blockedCIDRs.some((cidr) =>
        this.isIPInCIDR(clientIP, cidr),
      );
    }

    return false;
  }

  private isIPInCIDR(ip: string, cidr: string): boolean {
    try {
      const [network, prefixLength] = cidr.split('/');
      const prefix = parseInt(prefixLength, 10);

      if (this.isIPv4(ip) && this.isIPv4(network)) {
        return this.isIPv4InCIDR(ip, network, prefix);
      } else if (this.isIPv6(ip) && this.isIPv6(network)) {
        return this.isIPv6InCIDR(ip, network, prefix);
      }

      return false;
    } catch (error) {
      const err = error instanceof Error ? error : new Error(String(error));
      this.logger.error(`Invalid CIDR format: ${cidr}`, err.stack);
      return false;
    }
  }

  private isIPv4InCIDR(ip: string, network: string, prefix: number): boolean {
    const ipNum = this.ipv4ToNumber(ip);
    const networkNum = this.ipv4ToNumber(network);
    const mask = (0xffffffff << (32 - prefix)) >>> 0;

    return (ipNum & mask) === (networkNum & mask);
  }

  private isIPv6InCIDR(ip: string, network: string, prefix: number): boolean {
    // Simplified IPv6 CIDR check - in production, use a proper IPv6 library
    const ipParts = ip.split(':');
    const networkParts = network.split(':');

    const bitsToCheck = Math.min(prefix, 128);
    const fullGroups = Math.floor(bitsToCheck / 16);
    const remainingBits = bitsToCheck % 16;

    // Check full 16-bit groups
    for (let i = 0; i < fullGroups; i++) {
      if (ipParts[i] !== networkParts[i]) {
        return false;
      }
    }

    // Check remaining bits in the partial group
    if (remainingBits > 0 && fullGroups < ipParts.length) {
      const ipGroup = parseInt(ipParts[fullGroups] || '0', 16);
      const networkGroup = parseInt(networkParts[fullGroups] || '0', 16);
      const mask = (0xffff << (16 - remainingBits)) & 0xffff;

      return (ipGroup & mask) === (networkGroup & mask);
    }

    return true;
  }

  private ipv4ToNumber(ip: string): number {
    return (
      ip
        .split('.')
        .reduce((acc, octet) => (acc << 8) + parseInt(octet, 10), 0) >>> 0
    );
  }

  private isValidIP(ip: string): boolean {
    return this.isIPv4(ip) || this.isIPv6(ip);
  }

  private isIPv4(ip: string): boolean {
    const ipv4Regex = /^(\d{1,3}\.){3}\d{1,3}$/;
    if (!ipv4Regex.test(ip)) return false;

    return ip.split('.').every((octet) => {
      const num = parseInt(octet, 10);
      return num >= 0 && num <= 255;
    });
  }

  private isIPv6(ip: string): boolean {
    const ipv6Regex = /^([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$|^::1$|^::$/;
    return ipv6Regex.test(ip);
  }

  private async auditIPRestriction(
    userId: string,
    clientIP: string,
    request: RequestIPData,
    result: 'ALLOWED' | 'BLOCKED',
  ): Promise<void> {
    const auditData: IPAuditData = {
      userId,
      ip: clientIP,
      url: request.url,
      method: request.method,
      timestamp: new Date(),
      result,
      details: {
        correlationId: request.correlationId,
        userAgent: request.get('User-Agent'),
      },
    };

    try {
      await this.auditService.logSecurityEvent({
        userId,
        action: `IP_${result}`,
        resource: `${request.method} ${request.url}`,
        details: {
          ip: clientIP,
          ...auditData.details,
        },
        timestamp: new Date(),
        severity: result === 'BLOCKED' ? 'MEDIUM' : 'LOW',
        eventType: 'SYSTEM' as SecurityEventType,
      });
    } catch (error) {
      const err = error instanceof Error ? error : new Error(String(error));
      this.logger.error(
        `Failed to audit IP restriction: ${err.message}`,
        err.stack,
      );
    }
  }
}
