/* eslint-disable prettier/prettier */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Monitoramento } from './entities/monitoramento.entity';
import { MonitoramentoController } from './monitoramento.controller';
import { MonitoramentoService } from './monitoramento.service';
import { Plantacao } from '../plantacoes/entities/plantacao.entity';
import { AuthModule } from 'src/auth/auth.module';

@Module({
    imports: [TypeOrmModule.forFeature([Monitoramento, Plantacao]), AuthModule],
    controllers: [MonitoramentoController],
    providers: [MonitoramentoService],
})
export class MonitoramentoModule {}