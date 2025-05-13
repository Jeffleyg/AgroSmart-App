import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity()
export class User {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  name: string;

  @Column({ unique: true })
  email: string;

  @Column()
  password: string;

  @Column({ default: false })
  newPassword: string;

  // Adicione estes dois campos:
  @Column({ name: 'reset_token', nullable: true }) // Coluna opcional
  resetToken: string; // Armazenará o hash do token

  @Column({ name: 'reset_token_expiry', type: 'timestamp', nullable: true })
  resetTokenExpiry: Date; // Data de expiração do token
}