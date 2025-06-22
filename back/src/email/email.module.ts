// src/email/email.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm'; // Importe TypeOrmModule
import { ConfigModule } from '@nestjs/config'; // Importe ConfigModule
import { EmailController } from './email.controller'; // Se você for usá-lo
import { EmailService } from './email.service';
import { EmailLog } from './entities/email-log.entity';

@Module({
  imports: [
    ConfigModule, // Importe ConfigModule para que EmailService possa injetar ConfigService
    TypeOrmModule.forFeature([EmailLog]), // Registra sua entidade de log de e-mail
  ],
  controllers: [EmailController], // Mantenha se quiser um endpoint para e-mails
  providers: [EmailService],
  exports: [EmailService], // Exporta o serviço para ser usado em outros módulos (AuthService, AlertService)
})
export class EmailModule {}