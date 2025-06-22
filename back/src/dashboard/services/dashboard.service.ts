/* eslint-disable prettier/prettier */
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Irrigacao } from '../entities/irrigacao.entity';
import { ClimaFetcherService } from './clima-fetcher.service';

@Injectable()
export class DashboardService {
    constructor(
        @InjectRepository(Irrigacao)
        private irrigacaoRepo: Repository<Irrigacao>,
        private climaService: ClimaFetcherService,
    ) {}

    async getDashboardData() {
  const [clima, irrigacaoData] = await Promise.all([
    this.climaService.getClimaData(),
    this.irrigacaoRepo.findOne({
      where: {}, // necessário com findOne
      order: { data: 'DESC' },
    }),
  ]);

  return {
    clima,
    alertas: {
      tipos: ['Plantação', 'Sol', 'Plantação'],
      quantidades: [5, 2, 0],
    },
    metricas: [
      {
        irrigacao: irrigacaoData?.percentual || 50,
        alertas: 30,
        registro: 20,
      },
      {
        irrigacao: irrigacaoData?.percentual || 50,
        alertas: 30,
        registro: 20,
      },
    ],
    menus: ['Inicio', 'Meteo', 'Registro', 'Perfil', 'Serviços'],
  };
}

}