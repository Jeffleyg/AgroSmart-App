/* eslint-disable prettier/prettier */
import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { UserModule } from '../user/user.module';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { EmailService } from './email.service';

@Module({
  imports: [
    UserModule,
    JwtModule.register({
      secret: 'suaChaveSecreta', // Em produção, use variável de ambiente
      signOptions: { expiresIn: '1h' },
    }),
  ],
  providers: [AuthService, EmailService],
  controllers: [AuthController],
})
export class AuthModule {}