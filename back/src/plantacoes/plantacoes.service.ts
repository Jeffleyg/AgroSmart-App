/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-unnecessary-type-assertion */
// src/plantacoes/plantacoes.service.ts
/* eslint-disable prettier/prettier */
import { ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { QueryFailedError, Repository } from 'typeorm';
import { Plantacao } from './entities/plantacao.entity';
import { CreatePlantacaoDto } from './dto/create-plantacao.dto';

@Injectable()
export class PlantacoesService {
    constructor(
        @InjectRepository(Plantacao)
        private readonly plantacaoRepo: Repository<Plantacao>,
    ) {}

    async create(dto: CreatePlantacaoDto, userId: number) {
        const plantacao = this.plantacaoRepo.create({
        ...dto,
        userId ,
        });
        try {
        return await this.plantacaoRepo.save(plantacao);
        } catch (err) {
        // Se for violação de unicidade composta (userId+codigoPlantacao)
        if (
            err instanceof QueryFailedError &&
            (err as any).code === '23505'
        ) {
            throw new ConflictException(
            `Você já possui uma plantação com o código "${dto.codigoPlantacao}".`,
            );
        }
        // repassa outros erros
        throw err;
        }
    }

    async findAllByUser(userId: number) {
        return this.plantacaoRepo.find({
        where: { user: { id: userId } },
        order: { criadoEm: 'DESC' },
        });
    }

    private async ensureOwnership(
        codigoPlantacao: string,
        userId: number,
    ): Promise<Plantacao> {
        const plant = await this.plantacaoRepo.findOne({
        where: { codigoPlantacao, user: { id: userId } },
        });
        if (!plant) {
        throw new NotFoundException(
            'Plantação não encontrada ou sem permissão',
        );
        }
        return plant;
    }

    async updateByCodigoPlantacao(
        codigoPlantacao: string,
        dto: CreatePlantacaoDto,
        userId: number,
    ) {
        const plantacao = await this.ensureOwnership(
        codigoPlantacao,
        userId,
        );
        Object.assign(plantacao, dto);
        return this.plantacaoRepo.save(plantacao);
    }

    async deleteByCodigoPlantacao(
        codigoPlantacao: string,
        userId: number,
    ) {
        const plantacao = await this.ensureOwnership(
        codigoPlantacao,
        userId,
        );
        await this.plantacaoRepo.remove(plantacao);
        return { deleted: true };
    }
}