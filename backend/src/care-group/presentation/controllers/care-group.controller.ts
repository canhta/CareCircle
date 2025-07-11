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
import {
  FirebaseAuthGuard,
  FirebaseUserPayload,
} from '../../../identity-access/presentation/guards/firebase-auth.guard';
import {
  CareGroupService,
  CreateCareGroupDto,
  UpdateCareGroupDto,
  InviteMemberDto,
} from '../../application/services/care-group.service';
import { CareTaskService } from '../../application/services/care-task.service';
import { CareActivityService } from '../../application/services/care-activity.service';
import { CareRecipientService } from '../../application/services/care-recipient.service';
import {
  MemberRole,
  TaskStatus,
  TaskPriority,
  TaskCategory,
} from '@prisma/client';

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

export interface TaskResponse {
  id: string;
  groupId: string;
  recipientId: string | null;
  assigneeId: string | null;
  createdById: string;
  title: string;
  description: string | null;
  category: TaskCategory;
  status: TaskStatus;
  priority: TaskPriority;
  dueDate: string | null;
  completedAt: string | null;
  recurrence: Record<string, any> | null;
  metadata: Record<string, any>;
  createdAt: string;
  updatedAt: string;
}

export interface ActivityResponse {
  id: string;
  groupId: string;
  userId: string;
  type: string;
  title: string;
  description: string | null;
  metadata: Record<string, any>;
  createdAt: string;
}

export interface RecipientResponse {
  id: string;
  groupId: string;
  name: string;
  relationship: string;
  dateOfBirth: string | null;
  medicalConditions: string[];
  allergies: string[];
  medications: string[];
  emergencyContacts: Record<string, any>[];
  carePreferences: Record<string, any>;
  notes: string | null;
  isActive: boolean;
  createdAt: string;
  updatedAt: string;
}

@Controller('care-groups')
@UseGuards(FirebaseAuthGuard)
export class CareGroupController {
  constructor(
    private readonly careGroupService: CareGroupService,
    private readonly careTaskService: CareTaskService,
    private readonly careActivityService: CareActivityService,
    private readonly careRecipientService: CareRecipientService,
  ) {}

  /**
   * GET /care-groups
   * Get all care groups for the authenticated user
   */
  @Get()
  async getCareGroups(
    @Request() req: { user: FirebaseUserPayload },
  ): Promise<CareGroupResponse[]> {
    const userId = req.user.id;
    const careGroups = await this.careGroupService.getUserCareGroups(userId);

    return careGroups.map((group) => ({
      id: group.id,
      name: group.name,
      description: group.description,
      createdBy: group.createdBy,
      isActive: group.isActive,
      settings: group.settings,
      inviteCode: group.inviteCode,
      inviteExpiration: group.inviteExpiration?.toISOString() || null,
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
    @Request() req: { user: FirebaseUserPayload },
    @Body() createDto: CreateCareGroupDto,
  ): Promise<CareGroupResponse> {
    const userId = req.user.id;
    const careGroup = await this.careGroupService.createCareGroup(
      userId,
      createDto,
    );

    return {
      id: careGroup.id,
      name: careGroup.name,
      description: careGroup.description,
      createdBy: careGroup.createdBy,
      isActive: careGroup.isActive,
      settings: careGroup.settings,
      inviteCode: careGroup.inviteCode,
      inviteExpiration: careGroup.inviteExpiration?.toISOString() || null,
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
    @Request() req: { user: FirebaseUserPayload },
    @Param('id') groupId: string,
  ): Promise<CareGroupResponse> {
    const userId = req.user.id;
    const careGroup = await this.careGroupService.getCareGroupById(
      groupId,
      userId,
    );
    const stats = await this.careGroupService.getCareGroupStatistics(
      groupId,
      userId,
    );

    return {
      id: careGroup.id,
      name: careGroup.name,
      description: careGroup.description,
      createdBy: careGroup.createdBy,
      isActive: careGroup.isActive,
      settings: careGroup.settings,
      inviteCode: careGroup.inviteCode,
      inviteExpiration: careGroup.inviteExpiration?.toISOString() || null,
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
    @Request() req: { user: FirebaseUserPayload },
    @Param('id') groupId: string,
    @Body() updateDto: UpdateCareGroupDto,
  ): Promise<CareGroupResponse> {
    const userId = req.user.id;
    const careGroup = await this.careGroupService.updateCareGroup(
      groupId,
      userId,
      updateDto,
    );

    return {
      id: careGroup.id,
      name: careGroup.name,
      description: careGroup.description,
      createdBy: careGroup.createdBy,
      isActive: careGroup.isActive,
      settings: careGroup.settings,
      inviteCode: careGroup.inviteCode,
      inviteExpiration: careGroup.inviteExpiration?.toISOString() || null,
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
    @Request() req: { user: FirebaseUserPayload },
    @Param('id') groupId: string,
  ): Promise<void> {
    const userId = req.user.id;
    await this.careGroupService.deleteCareGroup(groupId, userId);
  }

  /**
   * GET /care-groups/:id/members
   * Get all members of a care group
   */
  @Get(':id/members')
  async getCareGroupMembers(
    @Request() req: { user: FirebaseUserPayload },
    @Param('id') groupId: string,
  ): Promise<MemberResponse[]> {
    const userId = req.user.id;
    const members = await this.careGroupService.getCareGroupMembers(
      groupId,
      userId,
    );

    return members.map((member) => ({
      id: member.id,
      groupId: member.groupId,
      userId: member.userId,
      role: member.role,
      customTitle: member.customTitle,
      isActive: member.isActive,
      canInviteMembers: member.canInviteMembers(),
      canManageTasks: member.canManageTasks(),
      canViewHealthData: member.canViewHealthData(),
      permissions: member.permissions,
      joinedAt: member.joinedAt.toISOString(),
      lastActiveAt: member.lastActive?.toISOString() || null,
    }));
  }

  /**
   * POST /care-groups/:id/invite
   * Invite a member to the care group
   */
  @Post(':id/invite')
  async inviteMember(
    @Request() req: { user: FirebaseUserPayload },
    @Param('id') groupId: string,
    @Body() inviteDto: InviteMemberDto,
  ): Promise<{ success: boolean; message: string }> {
    const userId = req.user.id;
    return this.careGroupService.inviteMember(groupId, userId, inviteDto);
  }

  /**
   * POST /care-groups/:id/join
   * Join a care group (for invited users)
   */
  @Post(':id/join')
  async joinCareGroup(
    @Request() req: { user: FirebaseUserPayload },
    @Param('id') groupId: string,
    @Body() joinDto: { invitationCode?: string },
  ): Promise<MemberResponse> {
    const userId = req.user.id;
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
      canInviteMembers: member.canInviteMembers(),
      canManageTasks: member.canManageTasks(),
      canViewHealthData: member.canViewHealthData(),
      permissions: member.permissions,
      joinedAt: member.joinedAt.toISOString(),
      lastActiveAt: member.lastActive?.toISOString() || null,
    };
  }

  /**
   * PUT /care-groups/:groupId/members/:memberId
   * Update member role and permissions
   */
  @Put(':groupId/members/:memberId')
  async updateMember(
    @Request() req: { user: FirebaseUserPayload },
    @Param('groupId') groupId: string,
    @Param('memberId') memberId: string,
    @Body()
    updateDto: {
      role?: MemberRole;
      customTitle?: string;
      canInviteMembers?: boolean;
      canManageTasks?: boolean;
      canViewHealthData?: boolean;
    },
  ): Promise<MemberResponse> {
    const userId = req.user.id;
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
      canInviteMembers: member.canInviteMembers(),
      canManageTasks: member.canManageTasks(),
      canViewHealthData: member.canViewHealthData(),
      permissions: member.permissions,
      joinedAt: member.joinedAt.toISOString(),
      lastActiveAt: member.lastActive?.toISOString() || null,
    };
  }

  /**
   * DELETE /care-groups/:groupId/members/:memberId
   * Remove a member from the care group
   */
  @Delete(':groupId/members/:memberId')
  @HttpCode(HttpStatus.NO_CONTENT)
  async removeMember(
    @Request() req: { user: FirebaseUserPayload },
    @Param('groupId') groupId: string,
    @Param('memberId') memberId: string,
  ): Promise<void> {
    const userId = req.user.id;
    await this.careGroupService.removeMember(groupId, memberId, userId);
  }

  /**
   * GET /care-groups/search
   * Search care groups by name
   */
  @Get('search')
  async searchCareGroups(
    @Request() req: { user: FirebaseUserPayload },
    @Query('q') searchTerm: string,
  ): Promise<CareGroupResponse[]> {
    const userId = req.user.id;
    const careGroups = await this.careGroupService.searchCareGroups(
      userId,
      searchTerm,
    );

    return careGroups.map((group) => ({
      id: group.id,
      name: group.name,
      description: group.description,
      createdBy: group.createdBy,
      isActive: group.isActive,
      settings: group.settings,
      inviteCode: group.inviteCode,
      inviteExpiration: group.inviteExpiration?.toISOString() || null,
      createdAt: group.createdAt.toISOString(),
      updatedAt: group.updatedAt.toISOString(),
    }));
  }

  // ============================================================================
  // TASK MANAGEMENT ENDPOINTS
  // ============================================================================

  /**
   * GET /care-groups/:id/tasks
   * Get tasks for a care group
   */
  @Get(':id/tasks')
  async getGroupTasks(
    @Request() req: { user: FirebaseUserPayload },
    @Param('id') groupId: string,
    @Query('status') status?: TaskStatus,
  ): Promise<TaskResponse[]> {
    const userId = req.user.id;
    const tasks = await this.careTaskService.getGroupTasks(groupId, userId, {
      status,
    });

    return tasks.map((task) => ({
      id: task.id,
      groupId: task.groupId,
      recipientId: task.recipientId,
      assigneeId: task.assigneeId,
      createdById: task.createdById,
      title: task.title,
      description: task.description,
      category: task.category,
      status: task.status,
      priority: task.priority,
      dueDate: task.dueDate?.toISOString() || null,
      completedAt: task.completedAt?.toISOString() || null,
      recurrence: task.recurrence,
      metadata: task.metadata,
      createdAt: task.createdAt.toISOString(),
      updatedAt: task.updatedAt.toISOString(),
    }));
  }

  // /**
  //  * POST /care-groups/:id/tasks
  //  * Create a new task in the care group
  //  */
  // @Post(':id/tasks')
  // @HttpCode(HttpStatus.CREATED)
  // async createTask(
  //   @Request() req,
  //   @Param('id') groupId: string,
  //   @Body() createDto: CreateTaskDto,
  // ): Promise<TaskResponse> {
  //   const userId = req.user.uid;
  //   const task = await this.careTaskService.createTask(
  //     groupId,
  //     userId,
  //     createDto,
  //   );

  //   return {
  //     id: task.id,
  //     groupId: task.groupId,
  //     recipientId: task.recipientId,
  //     assigneeId: task.assigneeId,
  //     createdById: task.createdById,
  //     title: task.title,
  //     description: task.description,
  //     category: task.category,
  //     status: task.status,
  //     priority: task.priority,
  //     dueDate: task.dueDate?.toISOString() || null,
  //     completedAt: task.completedAt?.toISOString() || null,
  //     isRecurring: task.isRecurring,
  //     recurringPattern: task.recurringPattern,
  //     metadata: task.metadata,
  //     createdAt: task.createdAt.toISOString(),
  //     updatedAt: task.updatedAt.toISOString(),
  //   };
  // }

  // /**
  //  * PUT /care-groups/:groupId/tasks/:taskId
  //  * Update a task
  //  */
  // @Put(':groupId/tasks/:taskId')
  // async updateTask(
  //   @Request() req,
  //   @Param('groupId') groupId: string,
  //   @Param('taskId') taskId: string,
  //   @Body() updateDto: UpdateTaskDto,
  // ): Promise<TaskResponse> {
  //   const userId = req.user.uid;
  //   const task = await this.careTaskService.updateTask(
  //     taskId,
  //     groupId,
  //     userId,
  //     updateDto,
  //   );

  //   return {
  //     id: task.id,
  //     groupId: task.groupId,
  //     recipientId: task.recipientId,
  //     assigneeId: task.assigneeId,
  //     createdById: task.createdById,
  //     title: task.title,
  //     description: task.description,
  //     category: task.category,
  //     status: task.status,
  //     priority: task.priority,
  //     dueDate: task.dueDate?.toISOString() || null,
  //     completedAt: task.completedAt?.toISOString() || null,
  //     isRecurring: task.isRecurring,
  //     recurringPattern: task.recurringPattern,
  //     metadata: task.metadata,
  //     createdAt: task.createdAt.toISOString(),
  //     updatedAt: task.updatedAt.toISOString(),
  //   };
  // }

  // /**
  //  * DELETE /care-groups/:groupId/tasks/:taskId
  //  * Delete a task
  //  */
  // @Delete(':groupId/tasks/:taskId')
  // @HttpCode(HttpStatus.NO_CONTENT)
  // async deleteTask(
  //   @Request() req,
  //   @Param('groupId') groupId: string,
  //   @Param('taskId') taskId: string,
  // ): Promise<void> {
  //   const userId = req.user.uid;
  //   await this.careTaskService.deleteTask(taskId, groupId, userId);
  // }
}
