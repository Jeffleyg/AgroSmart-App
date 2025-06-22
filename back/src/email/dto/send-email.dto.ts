// src/email/dto/send-email.dto.ts

import { IsEmail, IsNotEmpty, IsOptional, IsString } from 'class-validator';

export class SendEmailDto {
  @IsEmail()
  to: string;

  @IsString()
  @IsNotEmpty()
  subject: string;

  @IsOptional()
  @IsString()
  html?: string;

  @IsOptional()
  @IsString()
  template?: string;

  @IsOptional()
  context?: Record<string, any>;

  @IsOptional()
  @IsEmail()
  from?: string;
}
