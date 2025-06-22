/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable prettier/prettier */
import { Injectable } from '@nestjs/common';

@Injectable()
export class AlertService {
    gerarAlertas(previsoes: any[]) {
        const alertas: string[] = [];

        for (const dia of previsoes) {
        const data = new Date(dia.data).toLocaleDateString('pt-BR');

        // 1. Chuva muito forte
        if (dia.chuva >= 70) {
            alertas.push(`${data}: 🌧️ Risco de enchentes — Previsão de chuva muito forte (${dia.chuva}%).`);
        } else if (dia.chuva >= 50) {
            alertas.push(`${data}: Alerta de chuva forte (${dia.chuva}%).`);
        }

        // 2. Calor extremo
        if (dia.temperaturaMax >= 38) {
            alertas.push(`${data}: 🔥 Onda de calor — Temperatura pode atingir ${dia.temperaturaMax}°C.`);
        } else if (dia.temperaturaMax > 35) {
            alertas.push(`${data}: Calor intenso — Máx. prevista: ${dia.temperaturaMax}°C.`);
        }

        // 3. Frio intenso
        if (dia.temperaturaMin <= 5) {
            alertas.push(`${data}: ❄️ Risco de geada — Mínima prevista: ${dia.temperaturaMin}°C.`);
        } else if (dia.temperaturaMin < 10) {
            alertas.push(`${data}: Frio intenso — Mínima de ${dia.temperaturaMin}°C.`);
        }

        // 4. Chuva + frio = risco de fungos
        if (dia.chuva > 40 && dia.temperaturaMin < 15) {
            alertas.push(`${data}: ⚠️ Umidade alta e frio — Condições propícias a fungos no solo.`);
        }

        // 5. Oscilação térmica forte
        const oscilacao = dia.temperaturaMax - dia.temperaturaMin;
        if (oscilacao >= 15) {
            alertas.push(`${data}: 🌡️ Variação térmica forte (Δ ${oscilacao}°C) — risco de estresse nas plantas.`);
        }
        }

        return {
        total: alertas.length,
        mensagens: alertas,
        };
    }
}
