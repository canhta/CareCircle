import {
  IsString,
  IsEmail,
  IsEnum,
  IsOptional,
  IsBoolean,
} from 'class-validator';
import { CareRole } from '@prisma/client';

export class InviteCareGroupMemberDto {
  @IsEmail()
  email: string;

  @IsEnum(CareRole)
  @IsOptional()
  role?: CareRole = CareRole.MEMBER;

  @IsBoolean()
  @IsOptional()
  canViewHealth?: boolean = false;

  @IsBoolean()
  @IsOptional()
  canReceiveAlerts?: boolean = true;

  @IsBoolean()
  @IsOptional()
  canManageSettings?: boolean = false;

  @IsString()
  @IsOptional()
  message?: string;
}

export class AcceptInvitationDto {
  @IsString()
  token: string;
}

export class RejectInvitationDto {
  @IsString()
  token: string;
}
