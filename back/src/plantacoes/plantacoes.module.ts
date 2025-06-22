/* eslint-disable prettier/prettier */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Plantacao } from './entities/plantacao.entity';
import { PlantacoesService } from './plantacoes.service';
import { PlantacoesController } from './plantacoes.controller';
import { UserModule } from 'src/user/user.module';
import { EmailModule } from '../email/email.module';
import { User } from 'src/user/user.entity';

@Module({
    imports: [TypeOrmModule.forFeature([Plantacao, User]),
        // Importando o módulo de usuário para injeção de dependência
        UserModule, EmailModule],
    controllers: [PlantacoesController],
    providers: [PlantacoesService],
})
export class PlantacoesModule {}