/* eslint-disable prettier/prettier */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserModule } from './user/user.module';
import { AuthModule } from './auth/auth.module';
import { DashboardModule } from './dashboard/dashboard.module'; // Importando o módulo do Dashboard
import { ConfigModule } from '@nestjs/config';
import { PlantacoesModule } from './plantacoes/plantacoes.module';

@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: 'localhost',
      port: 5432,
      username: 'postgres',
      password: 'root',
      database: 'user_auth',
      entities: [__dirname + '/**/*.entity{.ts,.js}'],
      synchronize: true, // ATENÇÃO: usar apenas em desenvolvimento
    }),

    ConfigModule.forRoot({
      isGlobal: true, // <--- ESSENCIAL
    }),

    UserModule,
    AuthModule,
    DashboardModule, // Certifique-se de importar o módulo do Dashboard
    PlantacoesModule
  ],
})
export class AppModule {}