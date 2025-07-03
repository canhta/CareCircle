import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

export interface DeepLinkData {
  type: 'care_group_invitation' | 'care_group_access' | 'care_group_share';
  careGroupId?: string;
  invitationToken?: string;
  memberId?: string;
  action?: string;
}

@Injectable()
export class DeepLinkService {
  constructor(private configService: ConfigService) {}

  /**
   * Generate deep link for care group invitation
   */
  generateInvitationLink(token: string): string {
    const baseUrl = this.getAppBaseUrl();
    return `${baseUrl}/invite?token=${token}`;
  }

  /**
   * Generate deep link for direct care group access
   */
  generateCareGroupLink(careGroupId: string): string {
    const baseUrl = this.getAppBaseUrl();
    return `${baseUrl}/care-group/${careGroupId}`;
  }

  /**
   * Generate deep link for sharing care group
   */
  generateShareCareGroupLink(careGroupId: string, memberId?: string): string {
    const baseUrl = this.getAppBaseUrl();
    const params = new URLSearchParams({ careGroupId });

    if (memberId) {
      params.append('memberId', memberId);
    }

    return `${baseUrl}/share?${params.toString()}`;
  }

  /**
   * Generate deep link for specific care group actions
   */
  generateCareGroupActionLink(
    careGroupId: string,
    action: string,
    params?: Record<string, string>,
  ): string {
    const baseUrl = this.getAppBaseUrl();
    const urlParams = new URLSearchParams({
      careGroupId,
      action,
      ...params,
    });

    return `${baseUrl}/action?${urlParams.toString()}`;
  }

  /**
   * Parse deep link to extract data
   */
  parseDeepLink(url: string): DeepLinkData | null {
    try {
      const parsedUrl = new URL(url);
      const path = parsedUrl.pathname;
      const params = new URLSearchParams(parsedUrl.search);

      // Handle invitation links
      if (path === '/invite') {
        const token = params.get('token');
        if (token) {
          return {
            type: 'care_group_invitation',
            invitationToken: token,
          };
        }
      }

      // Handle direct care group access
      const careGroupMatch = path.match(/^\/care-group\/([a-zA-Z0-9-]+)$/);
      if (careGroupMatch) {
        return {
          type: 'care_group_access',
          careGroupId: careGroupMatch[1],
        };
      }

      // Handle share links
      if (path === '/share') {
        const careGroupId = params.get('careGroupId');
        const memberId = params.get('memberId');
        if (careGroupId) {
          return {
            type: 'care_group_share',
            careGroupId,
            memberId: memberId || undefined,
          };
        }
      }

      // Handle action links
      if (path === '/action') {
        const careGroupId = params.get('careGroupId');
        const action = params.get('action');
        if (careGroupId && action) {
          return {
            type: 'care_group_access',
            careGroupId,
            action,
          };
        }
      }

      return null;
    } catch (error) {
      console.error('Error parsing deep link:', error);
      return null;
    }
  }

  /**
   * Validate if deep link is properly formatted
   */
  validateDeepLink(url: string): boolean {
    const data = this.parseDeepLink(url);
    return data !== null;
  }

  /**
   * Get app base URL for deep links
   */
  private getAppBaseUrl(): string {
    // Try multiple config keys for flexibility
    const customScheme = this.configService.get<string>('APP_DEEP_LINK_SCHEME');
    const frontendUrl = this.configService.get<string>('FRONTEND_URL');
    const mobileScheme = this.configService.get<string>('MOBILE_APP_SCHEME');

    if (customScheme) return customScheme;
    if (mobileScheme) return mobileScheme;
    if (frontendUrl) return frontendUrl;

    // Default fallback
    return 'carecircle://';
  }

  /**
   * Generate universal link (web fallback for deep links)
   */
  generateUniversalLink(deepLink: string): string {
    const webBaseUrl =
      this.configService.get<string>('WEB_BASE_URL') ||
      'https://carecircle.app';
    const encodedDeepLink = encodeURIComponent(deepLink);
    return `${webBaseUrl}/deep-link?url=${encodedDeepLink}`;
  }

  /**
   * Create a comprehensive link object with both deep link and web fallback
   */
  createLinkBundle(deepLinkData: DeepLinkData): {
    deepLink: string;
    universalLink: string;
    qrCode?: string;
  } {
    let deepLink: string;

    switch (deepLinkData.type) {
      case 'care_group_invitation':
        if (!deepLinkData.invitationToken) {
          throw new Error('Invitation token is required');
        }
        deepLink = this.generateInvitationLink(deepLinkData.invitationToken);
        break;

      case 'care_group_access':
        if (!deepLinkData.careGroupId) {
          throw new Error('Care group ID is required');
        }
        if (deepLinkData.action) {
          deepLink = this.generateCareGroupActionLink(
            deepLinkData.careGroupId,
            deepLinkData.action,
          );
        } else {
          deepLink = this.generateCareGroupLink(deepLinkData.careGroupId);
        }
        break;

      case 'care_group_share':
        if (!deepLinkData.careGroupId) {
          throw new Error('Care group ID is required for sharing');
        }
        deepLink = this.generateShareCareGroupLink(
          deepLinkData.careGroupId,
          deepLinkData.memberId,
        );
        break;

      default:
        throw new Error('Invalid deep link type');
    }

    const universalLink = this.generateUniversalLink(deepLink);

    return {
      deepLink,
      universalLink,
      // QR code generation could be added here in the future
    };
  }
}
