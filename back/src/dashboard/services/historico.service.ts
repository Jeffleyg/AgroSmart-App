/* eslint-disable @typescript-eslint/no-unsafe-call */
/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable prettier/prettier */
// src/clima/historico.service.ts
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { ClimaHistorico } from '../entities/clima-historico.entity';
import { Repository } from 'typeorm';

@Injectable()
export class HistoricoService {
    constructor(
        @InjectRepository(ClimaHistorico)
        private readonly historicoRepo: Repository<ClimaHistorico>,
    ) {}

    async salvar(previsoes: any[], cidade: string) {
        const registros = previsoes.map((dia) => {
        const historico = this.historicoRepo.create({
            cidade,
            data: new Date(dia.data),
            tempMin: dia.temperaturaMin,
            tempMax: dia.temperaturaMax,
            chuva: dia.chuva,
            condicao: (dia.condicao ?? 'Desconhecida').toString(),
        });
        return historico;
        });

        return this.historicoRepo.save(registros);
    }

    async listar(cidade: string) {
        return this.historicoRepo.find({
        where: { cidade },
        order: { data: 'DESC' },
        });
    }
}
