/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-unsafe-call */
/* eslint-disable prettier/prettier */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserModule } from './user/user.module';
import { AuthModule } from './auth/auth.module';
import { DashboardModule } from './dashboard/dashboard.module'; // Importando o módulo do Dashboard
import { ConfigModule } from '@nestjs/config';
import { PlantacoesModule } from './plantacoes/plantacoes.module';
import { EmailModule } from './email/email.module';
import { HttpModule } from '@nestjs/axios';
import { MonitoramentoModule } from './monitoramento/monitoramento.module';

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
    HttpModule,
    AuthModule,
    EmailModule,
    DashboardModule, // Certifique-se de importar o módulo do Dashboard
    PlantacoesModule,
    MonitoramentoModule, // Importando o módulo de monitoramento
    // SchedulerModule.forRoot(), // Importando o módulo de agendamento se necessário
  ],
})
export class AppModule {}