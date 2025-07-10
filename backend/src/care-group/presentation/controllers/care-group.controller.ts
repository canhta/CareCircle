import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
  Query,
  UseGuards,
  Request,
  HttpStatus,
  HttpCode,
} from '@nestjs/common';
import { FirebaseAuthGuard } from '../../../identity-access/presentation/guards/firebase-auth.guard';
import { CareGroupService, CreateCareGroupDto, UpdateCareGroupDto, InviteMemberDto } from '../../application/services/care-group.service';
import { MemberRole } from '@prisma/client';

export interface CareGroupResponse {
  id: string;
  name: string;
  description: string | null;
  createdBy: string;
  isActive: boolean;
  settings: Record<string, any>;
  inviteCode: string | null;
  inviteExpiration: string | null;
  createdAt: string;
  updatedAt: string;
  memberCount?: number;
  taskCount?: number;
  activityCount?: number;
}

export interface MemberResponse {
  id: string;
  groupId: string;
  userId: string;
  role: MemberRole;
  customTitle: string | null;
  isActive: boolean;
  canInviteMembers: boolean;
  canManageTasks: boolean;
  canViewHealthData: boolean;
  permissions: string[];
  joinedAt: string;
  lastActiveAt: string | null;
}

@Controller('care-groups')
@UseGuards(FirebaseAuthGuard)
export class CareGroupController {
  constructor(private readonly careGroupService: CareGroupService) {}

  /**
   * GET /care-groups
   * Get all care groups for the authenticated user
   */
  @Get()
  async getCareGroups(@Request() req): Promise<CareGroupResponse[]> {
    const userId = req.user.uid;
    const careGroups = await this.careGroupService.getUserCareGroups(userId);

    return careGroups.map(group => ({
      id: group.id,
      name: group.name,
      description: group.description,
      type: group.type,
      createdBy: group.createdBy,
      isActive: group.isActive,
      settings: group.settings,
      emergencyContact: group.emergencyContact,
      createdAt: group.createdAt.toISOString(),
      updatedAt: group.updatedAt.toISOString(),
    }));
  }

  /**
   * POST /care-groups
   * Create a new care group
   */
  @Post()
  @HttpCode(HttpStatus.CREATED)
  async createCareGroup(
    @Request() req,
    @Body() createDto: CreateCareGroupDto,
  ): Promise<CareGroupResponse> {
    const userId = req.user.uid;
    const careGroup = await this.careGroupService.createCareGroup(userId, createDto);

    return {
      id: careGroup.id,
      name: careGroup.name,
      description: careGroup.description,
      type: careGroup.type,
      createdBy: careGroup.createdBy,
      isActive: careGroup.isActive,
      settings: careGroup.settings,
      emergencyContact: careGroup.emergencyContact,
      createdAt: careGroup.createdAt.toISOString(),
      updatedAt: careGroup.updatedAt.toISOString(),
    };
  }

  /**
   * GET /care-groups/:id
   * Get a specific care group by ID
   */
  @Get(':id')
  async getCareGroup(
    @Request() req,
    @Param('id') groupId: string,
  ): Promise<CareGroupResponse> {
    const userId = req.user.uid;
    const careGroup = await this.careGroupService.getCareGroupById(groupId, userId);
    const stats = await this.careGroupService.getCareGroupStatistics(groupId, userId);

    return {
      id: careGroup.id,
      name: careGroup.name,
      description: careGroup.description,
      type: careGroup.type,
      createdBy: careGroup.createdBy,
      isActive: careGroup.isActive,
      settings: careGroup.settings,
      emergencyContact: careGroup.emergencyContact,
      createdAt: careGroup.createdAt.toISOString(),
      updatedAt: careGroup.updatedAt.toISOString(),
      memberCount: stats.memberCount,
      taskCount: stats.taskCount,
      activityCount: stats.activityCount,
    };
  }

  /**
   * PUT /care-groups/:id
   * Update a care group
   */
  @Put(':id')
  async updateCareGroup(
    @Request() req,
    @Param('id') groupId: string,
    @Body() updateDto: UpdateCareGroupDto,
  ): Promise<CareGroupResponse> {
    const userId = req.user.uid;
    const careGroup = await this.careGroupService.updateCareGroup(
      groupId,
      userId,
      updateDto,
    );

    return {
      id: careGroup.id,
      name: careGroup.name,
      description: careGroup.description,
      type: careGroup.type,
      createdBy: careGroup.createdBy,
      isActive: careGroup.isActive,
      settings: careGroup.settings,
      emergencyContact: careGroup.emergencyContact,
      createdAt: careGroup.createdAt.toISOString(),
      updatedAt: careGroup.updatedAt.toISOString(),
    };
  }

  /**
   * DELETE /care-groups/:id
   * Delete a care group
   */
  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  async deleteCareGroup(
    @Request() req,
    @Param('id') groupId: string,
  ): Promise<void> {
    const userId = req.user.uid;
    await this.careGroupService.deleteCareGroup(groupId, userId);
  }

  /**
   * GET /care-groups/:id/members
   * Get all members of a care group
   */
  @Get(':id/members')
  async getCareGroupMembers(
    @Request() req,
    @Param('id') groupId: string,
  ): Promise<MemberResponse[]> {
    const userId = req.user.uid;
    const members = await this.careGroupService.getCareGroupMembers(groupId, userId);

    return members.map(member => ({
      id: member.id,
      groupId: member.groupId,
      userId: member.userId,
      role: member.role,
      customTitle: member.customTitle,
      isActive: member.isActive,
      canInviteMembers: member.canInviteMembers,
      canManageTasks: member.canManageTasks,
      canViewHealthData: member.canViewHealthData,
      permissions: member.permissions,
      joinedAt: member.joinedAt.toISOString(),
      lastActiveAt: member.lastActiveAt?.toISOString() || null,
    }));
  }

  /**
   * POST /care-groups/:id/invite
   * Invite a member to the care group
   */
  @Post(':id/invite')
  async inviteMember(
    @Request() req,
    @Param('id') groupId: string,
    @Body() inviteDto: InviteMemberDto,
  ): Promise<{ success: boolean; message: string }> {
    const userId = req.user.uid;
    return this.careGroupService.inviteMember(groupId, userId, inviteDto);
  }

  /**
   * POST /care-groups/:id/join
   * Join a care group (for invited users)
   */
  @Post(':id/join')
  async joinCareGroup(
    @Request() req,
    @Param('id') groupId: string,
    @Body() joinDto: { invitationCode?: string },
  ): Promise<MemberResponse> {
    const userId = req.user.uid;
    const member = await this.careGroupService.joinCareGroup(
      groupId,
      userId,
      joinDto.invitationCode,
    );

    return {
      id: member.id,
      groupId: member.groupId,
      userId: member.userId,
      role: member.role,
      customTitle: member.customTitle,
      isActive: member.isActive,
      canInviteMembers: member.canInviteMembers,
      canManageTasks: member.canManageTasks,
      canViewHealthData: member.canViewHealthData,
      permissions: member.permissions,
      joinedAt: member.joinedAt.toISOString(),
      lastActiveAt: member.lastActiveAt?.toISOString() || null,
    };
  }

  /**
   * PUT /care-groups/:groupId/members/:memberId
   * Update member role and permissions
   */
  @Put(':groupId/members/:memberId')
  async updateMember(
    @Request() req,
    @Param('groupId') groupId: string,
    @Param('memberId') memberId: string,
    @Body() updateDto: {
      role?: MemberRole;
      customTitle?: string;
      canInviteMembers?: boolean;
      canManageTasks?: boolean;
      canViewHealthData?: boolean;
    },
  ): Promise<MemberResponse> {
    const userId = req.user.uid;
    const member = await this.careGroupService.updateMember(
      groupId,
      memberId,
      userId,
      updateDto,
    );

    return {
      id: member.id,
      groupId: member.groupId,
      userId: member.userId,
      role: member.role,
      customTitle: member.customTitle,
      isActive: member.isActive,
      canInviteMembers: member.canInviteMembers,
      canManageTasks: member.canManageTasks,
      canViewHealthData: member.canViewHealthData,
      permissions: member.permissions,
      joinedAt: member.joinedAt.toISOString(),
      lastActiveAt: member.lastActiveAt?.toISOString() || null,
    };
  }

  /**
   * DELETE /care-groups/:groupId/members/:memberId
   * Remove a member from the care group
   */
  @Delete(':groupId/members/:memberId')
  @HttpCode(HttpStatus.NO_CONTENT)
  async removeMember(
    @Request() req,
    @Param('groupId') groupId: string,
    @Param('memberId') memberId: string,
  ): Promise<void> {
    const userId = req.user.uid;
    await this.careGroupService.removeMember(groupId, memberId, userId);
  }

  /**
   * GET /care-groups/search
   * Search care groups by name
   */
  @Get('search')
  async searchCareGroups(
    @Request() req,
    @Query('q') searchTerm: string,
  ): Promise<CareGroupResponse[]> {
    const userId = req.user.uid;
    const careGroups = await this.careGroupService.searchCareGroups(userId, searchTerm);

    return careGroups.map(group => ({
      id: group.id,
      name: group.name,
      description: group.description,
      type: group.type,
      createdBy: group.createdBy,
      isActive: group.isActive,
      settings: group.settings,
      emergencyContact: group.emergencyContact,
      createdAt: group.createdAt.toISOString(),
      updatedAt: group.updatedAt.toISOString(),
    }));
  }
}
