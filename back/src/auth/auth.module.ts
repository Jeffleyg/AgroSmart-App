/* eslint-disable prettier/prettier */
import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { UserModule } from '../user/user.module';
import { AuthService } from './auth.service';
<<<<<<< HEAD
 //import { AuthController } from './auth.controller';
//import { EmailService } from './email.service';
=======
import { AuthController } from './auth.controller';
>>>>>>> 17860cead8cc597c398697e7b26670be84d246d6

@Module({
  imports: [
    UserModule,
    JwtModule.register({
      secret: 'suaChaveSecreta', // Em produção, use variável de ambiente
      signOptions: { expiresIn: '1h' },
    }),
  ],
<<<<<<< HEAD
  //providers: [AuthService, EmailService],
   //controllers: [AuthController],
=======
  providers: [AuthService],
  controllers: [AuthController],
>>>>>>> 17860cead8cc597c398697e7b26670be84d246d6
})
export class AuthModule {}