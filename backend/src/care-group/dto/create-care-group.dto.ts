import { IsString, IsOptional, IsNotEmpty } from 'class-validator';

export class CreateCareGroupDto {
  @IsString()
  @IsNotEmpty()
  name: string;

  @IsString()
  @IsOptional()
  description?: string;
}
