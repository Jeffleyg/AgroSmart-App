/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-unsafe-call */
/* eslint-disable prettier/prettier */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
// src/dashboard/dashboard.service.ts
import { Injectable } from '@nestjs/common';
import { ClimaFetcherService } from './clima-fetcher.service';
import { AlertService } from './alert.service';
import { HistoricoService } from './historico.service';

@Injectable()
export class DashboardService {
  [x: string]: any;
  constructor(
    private readonly climaFetcher: ClimaFetcherService,
    private readonly alertService: AlertService,
    private readonly historicoService: HistoricoService,
  ) {}

  async getDashboard(cidade: string = 'São Paulo', userEmail?: string, userName?: string) {
    const climaAtual = await this.climaFetcher.getClimaData();
    const previsao = await this.climaFetcher.getPrevisao14Dias(cidade);
    const alertas = this.alertService.gerarAlertas(previsao);
    await this.historicoService.salvar(previsao, cidade);
    const historico = await this.historicoService.listar(cidade);

    // Análise de risco simples
    const riscoAlto = alertas.total >= 5;
    const recomendacao = riscoAlto
      ? 'Atenção: condições climáticas exigem cuidado com irrigação, pragas e proteção das plantações.'
      : 'Sem grandes riscos climáticos nos próximos dias. Mantenha os cuidados regulares.';
    if (riscoAlto && userEmail) {
      await this.emailService.sendEmail({
        to: userEmail,
        subject: '🚨 Alerta climático detectado no seu painel',
        html: `
          <p>Olá ${userName || ''},</p>
          <p>Seu painel identificou <strong>${alertas.total} alertas climáticos críticos</strong> para os próximos dias.</p>
          <ul>${alertas.mensagens.map(m => `<li>${m}</li>`).join('')}</ul>
          <p>Recomendamos tomar precauções com suas plantações.</p>
        `
      });
    }

      return {
        climaAtual,
        previsao,
        alertas,
        historico,
        analise: {
          risco: riscoAlto ? 'ALTO' : 'BAIXO',
          recomendacao,
        },
      };
  }
}
