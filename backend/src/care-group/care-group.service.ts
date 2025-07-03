import {
  Injectable,
  NotFoundException,
  BadRequestException,
  ForbiddenException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CareGroupInvitationService } from './care-group-invitation.service';
import { CreateCareGroupDto } from './dto/create-care-group.dto';
import {
  UpdateCareGroupDto,
  UpdateMemberRoleDto,
} from './dto/update-care-group.dto';
import { InviteCareGroupMemberDto } from './dto/invite-member.dto';
import { CareRole } from '@prisma/client';
import { randomBytes } from 'crypto';

@Injectable()
export class CareGroupService {
  constructor(
    private prisma: PrismaService,
    private invitationService: CareGroupInvitationService,
  ) {}

  /**
   * Create a new care group
   */
  async create(createCareGroupDto: CreateCareGroupDto, userId: string) {
    const inviteCode = this.generateInviteCode();

    const careGroup = await this.prisma.careGroup.create({
      data: {
        name: createCareGroupDto.name,
        description: createCareGroupDto.description,
        inviteCode,
        members: {
          create: {
            userId,
            role: CareRole.OWNER,
            canViewHealth: true,
            canReceiveAlerts: true,
            canManageSettings: true,
          },
        },
      },
      include: {
        members: {
          include: {
            user: {
              select: {
                id: true,
                email: true,
                firstName: true,
                lastName: true,
                avatar: true,
              },
            },
          },
        },
      },
    });

    return careGroup;
  }

  /**
   * Get all care groups for a user
   */
  async findAllForUser(userId: string) {
    return this.prisma.careGroup.findMany({
      where: {
        members: {
          some: {
            userId,
            isActive: true,
          },
        },
        isActive: true,
      },
      include: {
        members: {
          where: {
            isActive: true,
          },
          include: {
            user: {
              select: {
                id: true,
                email: true,
                firstName: true,
                lastName: true,
                avatar: true,
              },
            },
          },
        },
      },
    });
  }

  /**
   * Get a specific care group by ID
   */
  async findOne(id: string, userId: string) {
    const careGroup = await this.prisma.careGroup.findUnique({
      where: { id },
      include: {
        members: {
          where: {
            isActive: true,
          },
          include: {
            user: {
              select: {
                id: true,
                email: true,
                firstName: true,
                lastName: true,
                avatar: true,
              },
            },
          },
        },
      },
    });

    if (!careGroup) {
      throw new NotFoundException('Care group not found');
    }

    // Check if user is a member
    const membership = careGroup.members.find(
      (member) => member.userId === userId,
    );
    if (!membership) {
      throw new ForbiddenException('You are not a member of this care group');
    }

    return careGroup;
  }

  /**
   * Update a care group
   */
  async update(
    id: string,
    updateCareGroupDto: UpdateCareGroupDto,
    userId: string,
  ) {
    // Verify user has permission to update
    await this.verifyMemberPermission(id, userId, [
      CareRole.OWNER,
      CareRole.ADMIN,
    ]);

    return this.prisma.careGroup.update({
      where: { id },
      data: updateCareGroupDto,
      include: {
        members: {
          include: {
            user: {
              select: {
                id: true,
                email: true,
                firstName: true,
                lastName: true,
                avatar: true,
              },
            },
          },
        },
      },
    });
  }

  /**
   * Delete/deactivate a care group
   */
  async remove(id: string, userId: string) {
    // Only owner can delete
    await this.verifyMemberPermission(id, userId, [CareRole.OWNER]);

    return this.prisma.careGroup.update({
      where: { id },
      data: { isActive: false },
    });
  }

  /**
   * Invite a member to the care group
   */
  async inviteMember(
    careGroupId: string,
    inviteDto: InviteCareGroupMemberDto,
    invitedBy: string,
  ) {
    // Verify user has permission to invite
    await this.verifyMemberPermission(careGroupId, invitedBy, [
      CareRole.OWNER,
      CareRole.ADMIN,
    ]);

    const token = await this.invitationService.generateInvitationToken(
      careGroupId,
      inviteDto.email,
      inviteDto.role || CareRole.MEMBER,
      {
        canViewHealth: inviteDto.canViewHealth || false,
        canReceiveAlerts: inviteDto.canReceiveAlerts || true,
        canManageSettings: inviteDto.canManageSettings || false,
      },
      invitedBy,
    );

    const deepLink = this.invitationService.generateInvitationDeepLink(token);

    return {
      token,
      deepLink,
      message: 'Invitation created successfully',
    };
  }

  /**
   * Accept invitation
   */
  async acceptInvitation(token: string, userId: string) {
    await this.invitationService.acceptInvitation(token, userId);
    return { message: 'Invitation accepted successfully' };
  }

  /**
   * Reject invitation
   */
  async rejectInvitation(token: string, userId: string) {
    await this.invitationService.rejectInvitation(token, userId);
    return { message: 'Invitation rejected' };
  }

  /**
   * Update member role and permissions
   */
  async updateMemberRole(
    careGroupId: string,
    memberId: string,
    updateDto: UpdateMemberRoleDto,
    requesterId: string,
  ) {
    // Verify requester has permission
    await this.verifyMemberPermission(careGroupId, requesterId, [
      CareRole.OWNER,
      CareRole.ADMIN,
    ]);

    // Cannot change owner role (only one owner allowed)
    const targetMember = await this.prisma.careGroupMember.findUnique({
      where: { id: memberId },
    });

    if (!targetMember) {
      throw new NotFoundException('Member not found');
    }

    if (
      targetMember.role === CareRole.OWNER &&
      updateDto.role !== CareRole.OWNER
    ) {
      throw new BadRequestException('Cannot change owner role');
    }

    return this.prisma.careGroupMember.update({
      where: { id: memberId },
      data: updateDto,
      include: {
        user: {
          select: {
            id: true,
            email: true,
            firstName: true,
            lastName: true,
            avatar: true,
          },
        },
      },
    });
  }

  /**
   * Remove a member from care group
   */
  async removeMember(
    careGroupId: string,
    memberId: string,
    requesterId: string,
  ) {
    const requesterMembership = await this.verifyMemberPermission(
      careGroupId,
      requesterId,
      [CareRole.OWNER, CareRole.ADMIN],
    );

    const targetMember = await this.prisma.careGroupMember.findUnique({
      where: { id: memberId },
    });

    if (!targetMember) {
      throw new NotFoundException('Member not found');
    }

    // Cannot remove owner
    if (targetMember.role === CareRole.OWNER) {
      throw new BadRequestException('Cannot remove owner from care group');
    }

    // Admin cannot remove another admin (only owner can)
    if (
      targetMember.role === CareRole.ADMIN &&
      requesterMembership.role !== CareRole.OWNER
    ) {
      throw new ForbiddenException('Only owner can remove admin members');
    }

    return this.prisma.careGroupMember.update({
      where: { id: memberId },
      data: { isActive: false },
    });
  }

  /**
   * Leave care group (self-removal)
   */
  async leaveCareGroup(careGroupId: string, userId: string) {
    const membership = await this.prisma.careGroupMember.findUnique({
      where: {
        careGroupId_userId: {
          careGroupId,
          userId,
        },
      },
    });

    if (!membership) {
      throw new NotFoundException('You are not a member of this care group');
    }

    if (membership.role === CareRole.OWNER) {
      throw new BadRequestException(
        'Owner cannot leave care group. Transfer ownership first or delete the group.',
      );
    }

    return this.prisma.careGroupMember.update({
      where: { id: membership.id },
      data: { isActive: false },
    });
  }

  /**
   * Get all members of a care group
   */
  async getMembers(careGroupId: string, userId: string) {
    // Verify user is a member of the care group
    await this.verifyMemberPermission(careGroupId, userId, [
      CareRole.OWNER,
      CareRole.ADMIN,
      CareRole.CAREGIVER,
      CareRole.MEMBER,
    ]);

    return this.prisma.careGroupMember.findMany({
      where: {
        careGroupId,
        isActive: true,
      },
      include: {
        user: {
          select: {
            id: true,
            email: true,
            firstName: true,
            lastName: true,
            avatar: true,
          },
        },
      },
      orderBy: {
        joinedAt: 'asc',
      },
    });
  }

  /**
   * Helper method to verify member permissions
   */
  private async verifyMemberPermission(
    careGroupId: string,
    userId: string,
    allowedRoles: CareRole[],
  ) {
    const membership = await this.prisma.careGroupMember.findUnique({
      where: {
        careGroupId_userId: {
          careGroupId,
          userId,
        },
      },
    });

    if (!membership || !membership.isActive) {
      throw new ForbiddenException('You are not a member of this care group');
    }

    if (!allowedRoles.includes(membership.role)) {
      throw new ForbiddenException(
        `Insufficient permissions. Required: ${allowedRoles.join(', ')}`,
      );
    }

    return membership;
  }

  /**
   * Generate a unique invite code
   */
  private generateInviteCode(): string {
    return randomBytes(8).toString('hex').toUpperCase();
  }
}
