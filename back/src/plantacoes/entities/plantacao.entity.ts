/* eslint-disable @typescript-eslint/no-unsafe-return */
/* eslint-disable prettier/prettier */
// src/plantacoes/entities/plantacao.entity.ts
import { User } from 'src/user/user.entity';
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne, Index } from 'typeorm';

@Entity('plantacoes')
@Index(['userId', 'codigoPlantacao'], { unique: true }) // Garante que o código da plantação seja único
export class Plantacao {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column()
    nome: string;

    @Column()
    codigoPlantacao: string;

    @Column()
    tipoCultura: string;

    @Column({ type: 'date' })
    dataInicioPlantio: Date;

    @Column({ type: 'date' })
    dataPrevisaoColheita: Date;

    @Column({ type: 'date' })
    dataPlantio: Date;

    @CreateDateColumn()
    criadoEm: Date;

    @ManyToOne(() => User, user => user.plantacoes, { eager: false })
    user: User; // dono da plantação

    @Column({nullable: true})
    userId: number;
}
