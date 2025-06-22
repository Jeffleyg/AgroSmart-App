/* eslint-disable prettier/prettier */
import { Injectable, ConflictException, InternalServerErrorException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './user.entity';
import * as bcrypt from 'bcryptjs';
import { EmailService } from 'src/email/email.service';

@Injectable()
export class UserService {
  [x: string]: any;
  constructor(
    @InjectRepository(User)
    private userRepository: Repository<User>,
    private emailService: EmailService, // Supondo que você tenha um serviço de e-mail
  ) {}

  async createUser(email: string, password: string, name: string): Promise<Omit<User, 'password'>> {
    try {
      const existingUser = await this.userRepository.findOne({ where: { email } });
      if (existingUser) {
        throw new ConflictException('Email já está em uso');
      }

      const salt = await bcrypt.genSalt(10);
      const hashedPassword = await bcrypt.hash(password, salt);

      const user = this.userRepository.create({
        email,
        password: hashedPassword,
        name,
      });

      const savedUser = await this.userRepository.save(user);

      // Envio de e-mail de boas-vindas
      await this.emailService.sendEmail({
        to: email,
        subject: 'Bem-vindo!',
        html: `<h1>Olá ${name}!</h1><p>Obrigado por se registrar no nosso sistema.</p>`
      });

      const { password: _, ...userWithoutPassword } = savedUser;
      return userWithoutPassword;
    } catch (error) {
      if (error instanceof ConflictException) {
        throw error;
      }
      throw new InternalServerErrorException('Falha ao criar usuário');
    }
  }
  async findUserByEmail(email: string): Promise<User | null> {
    return this.userRepository.findOne({
      where: { email },
      select: ['id', 'email', 'name', 'password'] // Importante incluir password para validação
    });
  }
}