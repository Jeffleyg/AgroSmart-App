/* eslint-disable prettier/prettier */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Plantacao } from './entities/plantacao.entity';
import { PlantacoesService } from './plantacoes.service';
import { PlantacoesController } from './plantacoes.controller';
import { UserModule } from 'src/user/user.module';

@Module({
    imports: [TypeOrmModule.forFeature([Plantacao]),
        // Importando o módulo de usuário para injeção de dependência
        UserModule,],
    controllers: [PlantacoesController],
    providers: [PlantacoesService],
})
export class PlantacoesModule {}