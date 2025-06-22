/* eslint-disable prettier/prettier */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { HttpModule } from '@nestjs/axios';
import { DashboardController } from './dashboard.controller';
import { DashboardService } from './services/dashboard.service';
import { ClimaFetcherService } from './services/clima-fetcher.service';
import { Irrigacao } from './entities/irrigacao.entity';
import { ConfigModule } from '@nestjs/config';
import { HistoricoService } from './services/historico.service';
import { AlertService } from './services/alert.service';
import { ClimaHistorico } from './entities/clima-historico.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([Irrigacao, ClimaHistorico]),
    HttpModule,
    ConfigModule,

  ],
  controllers: [DashboardController],
  providers: [DashboardService, ClimaFetcherService, HistoricoService, AlertService],
  exports: [DashboardService, ClimaFetcherService, HistoricoService, AlertService],
})
export class DashboardModule {}