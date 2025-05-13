import { Entity, Column, PrimaryGeneratedColumn, CreateTimestampColumn } from 'typeorm';

@Entity()
export class EmailLog {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  to: string;

  @Column()
  subject: string;

  @Column()
  template: string;

  @Column({ default: 'pending' })
  status: string;

  @Column({ nullable: true })
  error?: string;

  @CreateTimestampColumn()
  createdAt: Date;
}