import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Alert } from './alert.entity';
import axios from 'axios';

@Injectable()
export class AlertService {
  constructor(
    @InjectRepository(Alert)
    private alertRepository: Repository<Alert>,
  ) {}

  async sendAlert(message: string, city: string): Promise<string> {
    console.log(`[ALERTA] 🚨 ${message}`);

    // Enviar para webhook (ex: https://webhook.site/seu-endpoint-aqui)
    try {
      await axios.post('https://webhook.site/13a1b0cf-9d8d-4cc8-ba0f-aab964109401', {
        message,
        city,
        timestamp: new Date().toISOString(),
      });
    } catch (err) {
      console.error('Erro ao enviar para o dispositivo externo:', err.message);
    }

    // Salvar no banco de dados
    await this.alertRepository.save({ message, city });

    return `Alerta enviado e salvo: ${message}`;
  }
}
