/* eslint-disable prettier/prettier */
// src/email/entities/email-log.entity.ts
import { Entity, Column, PrimaryGeneratedColumn, CreateDateColumn } from 'typeorm';

@Entity('email_logs')
export class EmailLog {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  to: string;

  @Column()
  subject: string;

  @Column({ type: 'text', nullable: true }) // <--- Adicione nullable: true AQUI
  body: string;

  @Column({ nullable: true })
  templateName: string;

  @Column({ type: 'jsonb', nullable: true })
  templateContext: any;

  @CreateDateColumn()
  createdAt: Date;

  @Column({ default: 'pending' })
  status: string;

  @Column({ nullable: true })
  error: string;
}