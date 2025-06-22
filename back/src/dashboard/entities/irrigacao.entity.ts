/* eslint-disable prettier/prettier */
import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity()
export class Irrigacao {
    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    percentual: number;

    @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
    data: Date;
}