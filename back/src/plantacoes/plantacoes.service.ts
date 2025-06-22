/* eslint-disable @typescript-eslint/no-unsafe-call */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-unnecessary-type-assertion */
// src/plantacoes/plantacoes.service.ts
/* eslint-disable prettier/prettier */
import { ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { QueryFailedError, Repository } from 'typeorm';
import { Plantacao } from './entities/plantacao.entity';
import { CreatePlantacaoDto } from './dto/create-plantacao.dto';
import { EmailService } from 'src/email/email.service';
import { User } from 'src/user/user.entity';

@Injectable()
export class PlantacoesService {
    [x: string]: any;
    constructor(
        @InjectRepository(Plantacao)
        private readonly plantacaoRepo: Repository<Plantacao>,
        private readonly emailService: EmailService, // Supondo que você tenha um serviço de email
        @InjectRepository(User)
        private readonly userRepo: Repository<User>, // Repositório de usuários para buscar o e-mail
    ) {}

    async create(dto: CreatePlantacaoDto, userId: number) {
        const plantacao = this.plantacaoRepo.create({
            ...dto,
            userId,
        });

        try {
            const savedPlantacao = await this.plantacaoRepo.save(plantacao);

            const user = await this.userRepo.findOne({ where: { id: userId } });

            if (!user) {
                throw new NotFoundException('Usuário não encontrado');
            }

            await this.emailService.sendEmail({
            to: user.email,
            subject: 'Nova plantação registrada',
            html: `<p>Olá ${user.name}, sua plantação <strong>${dto.nome}</strong> foi cadastrada com sucesso!</p>`,
            });

            return savedPlantacao;
        } catch (err) {
            if (
                err instanceof QueryFailedError &&
                (err as any).code === '23505'
            ) {
                throw new ConflictException(
                    `Você já possui uma plantação com o código "${dto.codigoPlantacao}".`,
                );
            }
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
        const plantacao = await this.ensureOwnership(codigoPlantacao, userId);

        Object.assign(plantacao, dto);
        const updated = await this.plantacaoRepo.save(plantacao);

        // Buscar o usuário para pegar o e-mail
        const user = await this.userRepo.findOne({ where: { id: userId } });

        if (user) {
            await this.emailService.sendEmail({
            to: user.email,
            subject: 'Plantação atualizada com sucesso',
            html: `<p>Olá ${user.name}, a plantação <strong>${dto.nome}</strong> foi atualizada com sucesso.</p>`,
            });
        }

        return updated;
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