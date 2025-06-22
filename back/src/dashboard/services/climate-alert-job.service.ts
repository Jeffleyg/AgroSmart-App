/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-unsafe-call */
/* eslint-disable @typescript-eslint/no-unused-vars */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable prettier/prettier */
// src/alert/climate-alert-job.service.ts
import { Injectable } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AlertService } from './alert.service';
import { EmailService } from 'src/email/email.service';
import { ClimaFetcherService } from './clima-fetcher.service';
import { User } from 'src/user/user.entity';

@Injectable()
export class ClimateAlertJobService {
    constructor(
        private readonly climaFetcher: ClimaFetcherService,
        private readonly alertService: AlertService,
        private readonly emailService: EmailService,
        @InjectRepository(User)
        private readonly userRepo: Repository<User>,
    ) {}

    // Executa todo dia às 6h da manhã
    @Cron(CronExpression.EVERY_DAY_AT_6AM)
    async checkAndNotifyUsers() {
        const users = await this.userRepo.find();

        for (const user of users) {
        const previsao = await this.climaFetcher.getPrevisao14Dias(user.cidade || 'São Paulo');
        const alertas = this.alertService.gerarAlertas(previsao);

        // Pega alertas dos próximos 2 dias
        const hoje = new Date();
        const doisDias = previsao.filter(p => {
            const data = new Date(p.data);
            const diff = (data.getTime() - hoje.getTime()) / (1000 * 60 * 60 * 24);
            return diff >= 1 && diff <= 2;
        });

        const alertasProximos = this.alertService.gerarAlertas(doisDias);

        if (alertasProximos.mensagens.length > 0) {
            await this.emailService.sendEmail({
            to: user.email,
            subject: '⏰ Alerta climático para os próximos dias',
            html: `
                <h2>Previsão de condições críticas para sua região:</h2>
                <ul>
                ${alertasProximos.mensagens.map(m => `<li>${m}</li>`).join('')}
                </ul>
                <p>Recomendamos tomar as precauções necessárias para proteger suas plantações.</p>
            `
            });

            console.log(`✅ Alerta enviado para ${user.email}`);
        }
        }
    }
}
