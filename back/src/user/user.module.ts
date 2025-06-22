/* eslint-disable prettier/prettier */
// src/user/user.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from './user.entity';
import { UserService } from './user.service';
import { UserController } from './user.controller';
import { EmailModule } from '../email/email.module'; // <--- IMPORTE O EmailModule AQUI

@Module({
  imports: [
    TypeOrmModule.forFeature([User]), // Registra a entidade User para este módulo
    EmailModule, // <--- ADICIONE O EmailModule AQUI
  ],
  providers: [UserService],
  controllers: [UserController],
  exports: [UserService], // Exporta UserService para que outros módulos (como AuthModule) possam usá-lo
})
export class UserModule {}