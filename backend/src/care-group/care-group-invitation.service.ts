import {
  Injectable,
  NotFoundException,
  BadRequestException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { PrismaService } from '../prisma/prisma.service';
import { DeepLinkService } from './deep-link.service';
import { CareRole } from '@prisma/client';

export interface InvitationTokenPayload {
  careGroupId: string;
  email: string;
  role: CareRole;
  permissions: {
    canViewHealth: boolean;
    canReceiveAlerts: boolean;
    canManageSettings: boolean;
  };
  invitedBy: string;
  type: 'care_group_invitation';
}

@Injectable()
export class CareGroupInvitationService {
  constructor(
    private prisma: PrismaService,
    private jwtService: JwtService,
    private configService: ConfigService,
    private deepLinkService: DeepLinkService,
  ) {}

  /**
   * Generate a secure invitation token
   */
  async generateInvitationToken(
    careGroupId: string,
    email: string,
    role: CareRole,
    permissions: {
      canViewHealth: boolean;
      canReceiveAlerts: boolean;
      canManageSettings: boolean;
    },
    invitedBy: string,
  ): Promise<string> {
    // Verify care group exists
    const careGroup = await this.prisma.careGroup.findUnique({
      where: { id: careGroupId },
    });

    if (!careGroup) {
      throw new NotFoundException('Care group not found');
    }

    // Check if user is already a member
    const existingMember = await this.prisma.careGroupMember.findUnique({
      where: {
        careGroupId_userId: {
          careGroupId,
          userId: email, // We'll use email as temporary identifier
        },
      },
    });

    if (existingMember) {
      throw new BadRequestException(
        'User is already a member of this care group',
      );
    }

    const payload: InvitationTokenPayload = {
      careGroupId,
      email,
      role,
      permissions,
      invitedBy,
      type: 'care_group_invitation',
    };

    // Generate token with 7 days expiration
    return this.jwtService.sign(payload, {
      secret: this.configService.get('JWT_SECRET'),
      expiresIn: '7d',
    });
  }

  /**
   * Verify and decode invitation token
   */
  async verifyInvitationToken(token: string): Promise<InvitationTokenPayload> {
    try {
      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
      const payload = this.jwtService.verify(token, {
        secret: this.configService.get('JWT_SECRET'),
      });

      // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
      if (payload.type !== 'care_group_invitation') {
        throw new BadRequestException('Invalid invitation token');
      }

      // Verify care group still exists
      const careGroup = await this.prisma.careGroup.findUnique({
        // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access
        where: { id: payload.careGroupId },
      });

      if (!careGroup || !careGroup.isActive) {
        throw new BadRequestException('Care group is no longer available');
      }

      // eslint-disable-next-line @typescript-eslint/no-unsafe-return
      return payload;
    } catch {
      throw new BadRequestException('Invalid or expired invitation token');
    }
  }

  /**
   * Accept invitation and add user to care group
   */
  async acceptInvitation(token: string, userId: string): Promise<void> {
    const payload = await this.verifyInvitationToken(token);

    // Verify user exists and email matches
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user || user.email !== payload.email) {
      throw new BadRequestException('Invalid user or email mismatch');
    }

    // Check if user is already a member (in case they were added between invitation and acceptance)
    const existingMember = await this.prisma.careGroupMember.findUnique({
      where: {
        careGroupId_userId: {
          careGroupId: payload.careGroupId,
          userId,
        },
      },
    });

    if (existingMember) {
      throw new BadRequestException(
        'User is already a member of this care group',
      );
    }

    // Add user to care group
    await this.prisma.careGroupMember.create({
      data: {
        careGroupId: payload.careGroupId,
        userId,
        role: payload.role,
        canViewHealth: payload.permissions.canViewHealth,
        canReceiveAlerts: payload.permissions.canReceiveAlerts,
        canManageSettings: payload.permissions.canManageSettings,
      },
    });
  }

  /**
   * Reject invitation (optional - for audit trail)
   */
  async rejectInvitation(token: string, userId: string): Promise<void> {
    const payload = await this.verifyInvitationToken(token);

    // Verify user exists and email matches
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user || user.email !== payload.email) {
      throw new BadRequestException('Invalid user or email mismatch');
    }

    // For now, just verify the token is valid
    // In the future, you might want to log this rejection
    console.log(
      `User ${userId} rejected invitation to care group ${payload.careGroupId}`,
    );
  }

  /**
   * Generate a deep link for invitation
   */
  generateInvitationDeepLink(token: string): string {
    return this.deepLinkService.generateInvitationLink(token);
  }

  /**
   * Generate comprehensive link bundle for invitation
   */
  generateInvitationLinkBundle(token: string) {
    return this.deepLinkService.createLinkBundle({
      type: 'care_group_invitation',
      invitationToken: token,
    });
  }
}
