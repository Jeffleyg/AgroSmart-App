/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-unsafe-call */
/* eslint-disable prettier/prettier */
// src/email/email.controller.ts
import { Controller, Post, Body, HttpCode, HttpStatus } from '@nestjs/common';
import { EmailService } from './email.service'; // <-- IMPORTE SEU EmailService
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';
import { EmailResponseDto } from './dto/email-response.dto'; // <--- IMPORTE O DTO DE RESPOSTA (se você criou)
import { SendEmailDto } from './dto/send-email.dto';  // <--- Se você tem um DTO específico para entrada, importe-o

@ApiTags('Email')
@Controller('email')
export class EmailController {
  constructor(private readonly emailService: EmailService) {}

  @Post('send')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Envia um e-mail de teste' })
  @ApiResponse({ status: 200, description: 'E-mail enviado com sucesso.', type: EmailResponseDto }) // <--- Adicione o tipo de resposta para Swagger
  @ApiResponse({ status: 500, description: 'Falha ao enviar e-mail.' })
  async sendTestEmail(@Body() sendEmailDto: SendEmailDto): Promise<EmailResponseDto> { // <--- Defina o tipo de retorno da Promise
    try {
      const success = await this.emailService.sendEmail(sendEmailDto); // Seu EmailService retorna boolean

      if (success) {
        //console.log(`✅ E-mail de teste enviado para ${sendEmailDto.to} com sucesso!`);
        return { success: true, message: 'E-mail enviado com sucesso!' };
      } else {
        // Se o emailService retornar false, significa que a falha já foi logada internamente.
        // O throw new Error aqui é para garantir que o Postman veja um status 500 se o emailService falhar.
        // Ou você pode apenas retornar { success: false, message: '...' } e deixar o status 200.
        // A opção mais comum é lançar uma HttpException para um status 500.
        throw new Error('Falha ao enviar e-mail através do serviço customizado.');
      }
    } catch (error: any) {
      console.error(`❌ Erro ao enviar e-mail de teste via controller para ${sendEmailDto.to}:`, error.message);
      // Retornar um erro genérico para o cliente, mas o detalhe está no log do servidor.
      // Se você quiser um status HTTP 500, lance uma HttpException:
      // throw new InternalServerErrorException('Falha ao enviar e-mail.');
      return { success: false, message: `Erro ao enviar e-mail: ${error.message}` };
    }
  }
}