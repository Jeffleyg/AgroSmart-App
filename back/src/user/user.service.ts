/* eslint-disable prettier/prettier */
import { Injectable, ConflictException, InternalServerErrorException } from '@nestjs/common';
// src/user/user.service.ts
import { Injectable, ConflictException, InternalServerErrorException, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './user.entity';
import * as bcrypt from 'bcryptjs';
import { EmailService } from '../email/email.service';

@Injectable()
export class UserService {
  private readonly logger = new Logger(UserService.name);

  constructor(
    @InjectRepository(User)
    private userRepository: Repository<User>,
    private emailService: EmailService,
  ) {}

  async createUser(email: string, password: string, name: string): Promise<Omit<User, 'password'>> {
    try {
      const existingUser = await this.userRepository.findOne({ where: { email } });
      if (existingUser) {
        throw new ConflictException('Email já está em uso');
      }

      const salt = await bcrypt.genSalt(10);
      const hashedPassword = await bcrypt.hash(password, salt);

      // Cria e salva o usuário
      const user = this.userRepository.create({

      const newUser = this.userRepository.create({
        email,
        password: hashedPassword,
        name,
        newPassword: true, // <--- Agora é um booleano, pois a entidade foi corrigida
      });


      const savedUser = await this.userRepository.save(user);

      // Remove a senha antes de retornar

      // FORÇAR TIPAGEM AQUI: TypeORM.save() de uma única entidade retorna a própria entidade.
      const savedUser: User = await this.userRepository.save(newUser); // <--- CORREÇÃO AQUI: Tipagem explícita para User

      // --- LOGICA DE ENVIO DE E-MAIL AQUI ---
      try {
        const emailOptions = {
          to: savedUser.email, // Agora savedUser é tipo User, então .email existe
          subject: 'Bem-vindo(a) ao AgroSmart!',
          template: 'welcome',
          context: { name: savedUser.name }, // .name existe
        };
        const emailSent = await this.emailService.sendEmail(emailOptions);

        if (emailSent) {
          this.logger.log(`✅ E-mail de boas-vindas enviado para ${savedUser.email}`);
        } else {
          this.logger.warn(`⚠️ Falha ao enviar e-mail de boas-vindas para ${savedUser.email}. Verifique os logs do EmailService.`);
        }
      } catch (emailError: any) {
        this.logger.error(`❌ Erro inesperado ao tentar enviar e-mail de boas-vindas para ${savedUser.email}: ${emailError.message}`);
      }
      // --- FIM DA LOGICA DE ENVIO DE E-MAIL ---

      // Remove a senha antes de retornar (agora `savedUser` é User, então .password existe)
      const { password: _, ...userWithoutPassword } = savedUser;
      return userWithoutPassword; // Agora userWithoutPassword é Omit<User, 'password'>
    } catch (error) {
      if (error instanceof ConflictException) {
        throw error;
      }
      this.logger.error(`Falha ao criar usuário: ${error.message}`, error.stack);
      throw new InternalServerErrorException('Falha ao criar usuário');
    }
  }

  async findUserByEmail(email: string): Promise<User | null> {
    return this.userRepository.findOne({
      where: { email },
      select: ['id', 'email', 'name', 'password', 'newPassword', 'resetToken', 'resetTokenExpiry'], // Inclua todos os campos necessários
    });
  }
}