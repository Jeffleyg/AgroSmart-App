// src/alert/alert.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Alert } from './alert.entity';
import { AlertService } from './alert.service';
import { AlertController } from './alert.controller';

@Module({
  imports: [
    // Registra o provider AlertRepository
    TypeOrmModule.forFeature([Alert]),
  ],
  providers: [AlertService],
  controllers: [AlertController],
  exports: [AlertService],  // exporta o serviço pra quem importar esse módulo
})
export class AlertModule {}
