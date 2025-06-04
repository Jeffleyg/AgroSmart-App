/* eslint-disable prettier/prettier */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { HttpModule } from '@nestjs/axios';
import { DashboardController } from './dashboard.controller';
import { DashboardService } from './services/dashboard.service';
import { ClimaFetcherService } from './services/clima-fetcher.service';
import { Irrigacao } from './entities/irrigacao.entity';
import { ConfigModule } from '@nestjs/config';

@Module({
  imports: [
    TypeOrmModule.forFeature([Irrigacao]),
    HttpModule,
    ConfigModule,
  ],
  controllers: [DashboardController],
  providers: [DashboardService, ClimaFetcherService],
})
export class DashboardModule {}