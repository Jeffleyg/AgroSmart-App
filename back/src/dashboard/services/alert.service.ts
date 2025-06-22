/* eslint-disable prettier/prettier */
import { Injectable } from '@nestjs/common';

@Injectable()
export class AlertService {
    gerarAlertas(previsoes: any[]) {
        const alertas: string[] = [];

        for (const dia of previsoes) {
        const data = new Date(dia.data).toLocaleDateString('pt-BR');

        if (dia.chuva >= 50) {
            alertas.push(`${data}: Alerta de chuva forte (≥ 50%).`);
        }

        if (dia.temperaturaMax > 35) {
            alertas.push(`${data}: Alerta de calor extremo (>${dia.temperaturaMax}°C).`);
        }

        if (dia.temperaturaMin < 10) {
            alertas.push(`${data}: Frio intenso (mín. < 10°C).`);
        }

        if (dia.chuva > 0 && dia.temperaturaMin < 15) {
            alertas.push(`${data}: Possível geada ou solo úmido (chuva: ${dia.chuva}mm).`);
        }
        }

        return {
        total: alertas.length,
        mensagens: alertas,
        };
    }
}
