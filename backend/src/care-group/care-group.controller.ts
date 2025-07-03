import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  UseGuards,
  Request,
  Query,
} from '@nestjs/common';
import { CareGroupService } from './care-group.service';
import { CareGroupInvitationService } from './care-group-invitation.service';
import { CareGroupDashboardService } from './care-group-dashboard.service';
import { DeepLinkService } from './deep-link.service';
import { CreateCareGroupDto } from './dto/create-care-group.dto';
import {
  InviteCareGroupMemberDto,
  AcceptInvitationDto,
  RejectInvitationDto,
} from './dto/invite-member.dto';
import {
  UpdateCareGroupDto,
  UpdateMemberRoleDto,
} from './dto/update-care-group.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import {
  CareGroupRoles,
  CareGroupRolesGuard,
} from './guards/care-group-roles.guard';
import { CareRole } from '@prisma/client';

interface AuthenticatedRequest {
  user: {
    sub: string;
    email: string;
  };
}

@Controller('care-groups')
@UseGuards(JwtAuthGuard)
export class CareGroupController {
  constructor(
    private readonly careGroupService: CareGroupService,
    private readonly invitationService: CareGroupInvitationService,
    private readonly dashboardService: CareGroupDashboardService,
    private readonly deepLinkService: DeepLinkService,
  ) {}

  @Post()
  async create(
    @Body() createCareGroupDto: CreateCareGroupDto,
    @Request() req: AuthenticatedRequest,
  ) {
    return this.careGroupService.create(createCareGroupDto, req.user.sub);
  }

  @Get()
  async findAll(@Request() req: AuthenticatedRequest) {
    return this.careGroupService.findAllForUser(req.user.sub);
  }

  @Get(':id')
  async findOne(@Param('id') id: string, @Request() req: AuthenticatedRequest) {
    return this.careGroupService.findOne(id, req.user.sub);
  }

  @Patch(':id')
  @UseGuards(CareGroupRolesGuard)
  @CareGroupRoles(CareRole.OWNER, CareRole.ADMIN)
  async update(
    @Param('id') id: string,
    @Body() updateCareGroupDto: UpdateCareGroupDto,
    @Request() req: AuthenticatedRequest,
  ) {
    return this.careGroupService.update(id, updateCareGroupDto, req.user.sub);
  }

  @Delete(':id')
  @UseGuards(CareGroupRolesGuard)
  @CareGroupRoles(CareRole.OWNER)
  async remove(@Param('id') id: string, @Request() req: AuthenticatedRequest) {
    return this.careGroupService.remove(id, req.user.sub);
  }

  // Member management endpoints
  @Post(':id/invite')
  @UseGuards(CareGroupRolesGuard)
  @CareGroupRoles(CareRole.OWNER, CareRole.ADMIN)
  async inviteMember(
    @Param('id') careGroupId: string,
    @Body() inviteDto: InviteCareGroupMemberDto,
    @Request() req: AuthenticatedRequest,
  ) {
    const token = await this.invitationService.generateInvitationToken(
      careGroupId,
      inviteDto.email,
      inviteDto.role || CareRole.MEMBER,
      {
        canViewHealth: inviteDto.canViewHealth || false,
        canReceiveAlerts: inviteDto.canReceiveAlerts || true,
        canManageSettings: inviteDto.canManageSettings || false,
      },
      req.user.sub,
    );

    const deepLink = this.invitationService.generateInvitationDeepLink(token);

    return {
      token,
      deepLink,
      message: 'Invitation created successfully',
    };
  }

  @Post('invitations/accept')
  async acceptInvitation(
    @Body() acceptDto: AcceptInvitationDto,
    @Request() req: AuthenticatedRequest,
  ) {
    await this.invitationService.acceptInvitation(
      acceptDto.token,
      req.user.sub,
    );
    return { message: 'Invitation accepted successfully' };
  }

  @Post('invitations/reject')
  async rejectInvitation(
    @Body() rejectDto: RejectInvitationDto,
    @Request() req: AuthenticatedRequest,
  ) {
    await this.invitationService.rejectInvitation(
      rejectDto.token,
      req.user.sub,
    );
    return { message: 'Invitation rejected' };
  }

  @Get('invitations/verify')
  async verifyInvitation(@Query('token') token: string) {
    const payload = await this.invitationService.verifyInvitationToken(token);
    return {
      valid: true,
      careGroupId: payload.careGroupId,
      role: payload.role,
      email: payload.email,
    };
  }

  @Get(':id/members')
  getMembers(
    @Param('id') careGroupId: string,
    @Request() req: AuthenticatedRequest,
  ) {
    return this.careGroupService.getMembers(careGroupId, req.user.sub);
  }

  @Patch(':careGroupId/members/:memberId')
  @UseGuards(CareGroupRolesGuard)
  @CareGroupRoles(CareRole.OWNER, CareRole.ADMIN)
  async updateMemberRole(
    @Param('careGroupId') careGroupId: string,
    @Param('memberId') memberId: string,
    @Body() updateDto: UpdateMemberRoleDto,
    @Request() req: AuthenticatedRequest,
  ) {
    return this.careGroupService.updateMemberRole(
      careGroupId,
      memberId,
      updateDto,
      req.user.sub,
    );
  }

  @Delete(':careGroupId/members/:memberId')
  @UseGuards(CareGroupRolesGuard)
  @CareGroupRoles(CareRole.OWNER, CareRole.ADMIN)
  async removeMember(
    @Param('careGroupId') careGroupId: string,
    @Param('memberId') memberId: string,
    @Request() req: AuthenticatedRequest,
  ) {
    await this.careGroupService.removeMember(
      careGroupId,
      memberId,
      req.user.sub,
    );
    return { message: 'Member removed successfully' };
  }

  @Post(':careGroupId/leave')
  async leaveCareGroup(
    @Param('careGroupId') careGroupId: string,
    @Request() req: AuthenticatedRequest,
  ) {
    await this.careGroupService.leaveCareGroup(careGroupId, req.user.sub);
    return { message: 'Left care group successfully' };
  }

  // Dashboard endpoints
  @Get(':id/dashboard')
  async getDashboard(
    @Param('id') careGroupId: string,
    @Request() req: AuthenticatedRequest,
  ) {
    return this.dashboardService.getDashboard(careGroupId, req.user.sub);
  }

  @Get(':id/dashboard/health-summary')
  async getHealthSummary(
    @Param('id') careGroupId: string,
    @Request() req: AuthenticatedRequest,
  ) {
    return this.dashboardService.getHealthSummary(careGroupId, req.user.sub);
  }

  @Get(':id/deep-link')
  async generateDeepLink(
    @Param('id') careGroupId: string,
    @Request() req: AuthenticatedRequest,
    @Query('action') action?: string,
  ) {
    // Verify user is a member
    await this.careGroupService.findOne(careGroupId, req.user.sub);

    const deepLinkData = {
      type: 'care_group_access' as const,
      careGroupId,
      action,
    };

    return this.deepLinkService.createLinkBundle(deepLinkData);
  }

  @Get(':id/share-link')
  async generateShareLink(
    @Param('id') careGroupId: string,
    @Request() req: AuthenticatedRequest,
  ) {
    // Verify user is a member
    await this.careGroupService.findOne(careGroupId, req.user.sub);

    const deepLinkData = {
      type: 'care_group_share' as const,
      careGroupId,
      memberId: req.user.sub,
    };

    return this.deepLinkService.createLinkBundle(deepLinkData);
  }
}
