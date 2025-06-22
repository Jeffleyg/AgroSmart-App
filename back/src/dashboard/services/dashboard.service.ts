/* eslint-disable prettier/prettier */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
// src/dashboard/dashboard.service.ts
import { Injectable } from '@nestjs/common';
import { ClimaFetcherService } from './clima-fetcher.service';
import { AlertService } from './alert.service';
import { HistoricoService } from './historico.service';

@Injectable()
export class DashboardService {
  constructor(
    private readonly climaFetcher: ClimaFetcherService,
    private readonly alertService: AlertService,
    private readonly historicoService: HistoricoService,
  ) {}

  async getDashboard(cidade: string = 'São Paulo') {
    const climaAtual = await this.climaFetcher.getClimaData();
    const previsao = await this.climaFetcher.getPrevisao14Dias();
    const alertas = this.alertService.gerarAlertas(previsao);
    const historico = await this.historicoService.listar(cidade);

    return {
      climaAtual,
      previsao,
      alertas,
      historico,
    };
  }
}
