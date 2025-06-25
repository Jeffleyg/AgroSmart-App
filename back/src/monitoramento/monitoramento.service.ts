/* eslint-disable prettier/prettier */
import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Monitoramento } from './entities/monitoramento.entity';
import { CreateMonitoramentoDto } from './dto/create-monitoramento.dto';
import { Plantacao } from '../plantacoes/entities/plantacao.entity';

@Injectable()
export class MonitoramentoService {
    constructor(
        @InjectRepository(Monitoramento)
        private readonly monitoramentoRepo: Repository<Monitoramento>,
        @InjectRepository(Plantacao)
        private readonly plantacaoRepo: Repository<Plantacao>,
    ) {}

    async create(dto: CreateMonitoramentoDto, userId: number) {
        // Verifica se a plantação pertence ao usuário
        const plantacao = await this.plantacaoRepo.findOne({
                where: {
                    id: dto.plantacaoId,
                    user: { id: userId },
    },
        });

        if (!plantacao) {
            throw new NotFoundException('Plantação não encontrada ou não pertence ao usuário');
        }

        const monitoramento = this.monitoramentoRepo.create({
            ...dto,
            plantacao,
        });

        return this.monitoramentoRepo.save(monitoramento);
    }

    async getUltimoPorUsuario(userId: number) {
        return this.monitoramentoRepo.createQueryBuilder('m')
            .leftJoinAndSelect('m.plantacao', 'plantacao')
            .where('plantacao.userId = :userId', { userId })
            .orderBy('m.dataHora', 'DESC')
            .getOne();
    }

    async getHistoricoPorUsuario(userId: number) {
        return this.monitoramentoRepo.createQueryBuilder('m')
            .leftJoinAndSelect('m.plantacao', 'plantacao')
            .where('plantacao.userId = :userId', { userId })
            .orderBy('m.dataHora', 'DESC')
            .getMany();
    }
}