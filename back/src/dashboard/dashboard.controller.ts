/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable @typescript-eslint/no-unsafe-return */
/* eslint-disable prettier/prettier */
import { Controller, Get, Post, Query } from '@nestjs/common';
import { DashboardService } from './services/dashboard.service';
import { ClimaFetcherService } from './services/clima-fetcher.service'; // Importing the ClimaFetcherService
import { AlertService } from './services/alert.service';
import { HistoricoService } from './services/historico.service'; // Importing the HistoricoService

@Controller('dashboard')
export class DashboardController {
  constructor(
    private readonly dashboardService: DashboardService,
    private readonly climaFetcherService: ClimaFetcherService, // Injecting the ClimaFetcherService
    private readonly alertService: AlertService, // Injecting the AlertService
    private readonly historicoService: HistoricoService, // Injecting the HistoricoService

  ) {}

  @Get()
  async getData() {
    return this.dashboardService.getDashboard();
  }

  @Get('clima')
  async getClimaData() {
    return this.climaFetcherService.getClimaData();
  }

  @Get('dias')
  async getPrevisao() {
    return this.climaFetcherService.getPrevisao14Dias();
  }

  @Get('alertas')
  async getAlertas() {
    const previsoes = await this.climaFetcherService.getPrevisao14Dias();
    return this.alertService.gerarAlertas(previsoes);
  }

  @Get('historico')
  listarHistorico(@Query('cidade') cidade: string) {
    return this.historicoService.listar(cidade);
  }

  @Post('salvar-historico')
  async salvar(@Query('cidade') cidade: string) {
    const previsoes = await this.climaFetcherService.getPrevisao14Dias(cidade);
    return this.historicoService.salvar(previsoes, cidade);
  }
}