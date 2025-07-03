import { IsBoolean, IsOptional, IsString } from 'class-validator';

export class UpdateConsentDto {
  @IsOptional()
  @IsBoolean()
  dataProcessingConsent?: boolean;

  @IsOptional()
  @IsBoolean()
  marketingConsent?: boolean;

  @IsOptional()
  @IsBoolean()
  analyticsConsent?: boolean;

  @IsOptional()
  @IsBoolean()
  healthDataSharingConsent?: boolean;

  @IsOptional()
  @IsString()
  consentVersion?: string;
}

export class ConsentResponseDto {
  dataProcessingConsent: boolean;
  marketingConsent: boolean;
  analyticsConsent: boolean;
  healthDataSharingConsent: boolean;
  consentVersion?: string;
  consentDate?: Date;
}
