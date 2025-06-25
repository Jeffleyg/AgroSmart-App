/* eslint-disable prettier/prettier */
/* eslint-disable @typescript-eslint/no-unsafe-return */
import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, CreateDateColumn } from 'typeorm';
import { Plantacao } from '../../plantacoes/entities/plantacao.entity';

@Entity('monitoramentos')
export class Monitoramento {
    @PrimaryGeneratedColumn()
    id: number;

    @Column({ type: 'decimal', precision: 5, scale: 2 })
    umidadeSolo: number;

    @Column()
    estadoPlantas: string;

    @Column({ nullable: true })
    observacoes?: string;

    @CreateDateColumn()
    dataHora: Date;

    @ManyToOne(() => Plantacao, plantacao => plantacao.monitoramentos)
    plantacao: Plantacao;

    @Column()
    plantacaoId: string;
}