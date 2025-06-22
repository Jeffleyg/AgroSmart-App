import { IsBoolean, IsOptional, IsString } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class EmailResponseDto {
  @ApiProperty({ description: 'Indica se o e-mail foi enviado com sucesso.' })
  @IsBoolean()
  success: boolean;

  @ApiProperty({
    description: 'Mensagem descritiva do resultado do envio.',
    required: false,
  })
  @IsOptional()
  @IsString()
  message?: string;
}
