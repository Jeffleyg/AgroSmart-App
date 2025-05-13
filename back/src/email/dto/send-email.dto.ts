// send-email.dto.ts
import { IsEmail, IsNotEmpty, IsString } from 'class-validator';

export class SendEmailDto {
  @IsEmail()
  to: string;

  @IsString()
  @IsNotEmpty()
  subject: string;

  @IsString()
  @IsNotEmpty()
  template: string;

  context?: Record<string, any>;
}

// email-response.dto.ts
export class EmailResponseDto {
    success: boolean;
    message: string;
}