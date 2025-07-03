import { IsString, IsOptional, IsBoolean, IsEnum } from 'class-validator';
import { CareRole } from '@prisma/client';

export class UpdateCareGroupDto {
  @IsString()
  @IsOptional()
  name?: string;

  @IsString()
  @IsOptional()
  description?: string;

  @IsBoolean()
  @IsOptional()
  isActive?: boolean;
}

export class UpdateMemberRoleDto {
  @IsEnum(CareRole)
  role: CareRole;

  @IsBoolean()
  @IsOptional()
  canViewHealth?: boolean;

  @IsBoolean()
  @IsOptional()
  canReceiveAlerts?: boolean;

  @IsBoolean()
  @IsOptional()
  canManageSettings?: boolean;
}
