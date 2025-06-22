/* eslint-disable prettier/prettier */
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity('clima_historico')
export class ClimaHistorico {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column()
    cidade: string;

    @Column({ type: 'timestamp' })
    data: Date;

    @Column('float')
    tempMin: number;

    @Column('float')
    tempMax: number;

    @Column('float')
    chuva: number;

    @Column()
    condicao: string;

    @CreateDateColumn()
    criadoEm: Date;
}
