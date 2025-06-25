/* eslint-disable prettier/prettier */
/* eslint-disable @typescript-eslint/no-unsafe-call */
/* eslint-disable @typescript-eslint/no-unsafe-return */
/* eslint-disable @typescript-eslint/no-unsafe-member-access */
// src/plantacoes/plantacoes.controller.ts
/* eslint-disable prettier/prettier */
/* eslint-disable @typescript-eslint/no-unsafe-argument */
import {
    Controller,
    Post,
    Body,
    Get,
    Param,
    Delete,
    UseGuards,
    Request,
    } from '@nestjs/common';
import { JwtAuthGuard } from 'src/auth/jwt-auth.guard';
import { PlantacoesService } from './plantacoes.service';
import { CreatePlantacaoDto } from './dto/create-plantacao.dto';

@UseGuards(JwtAuthGuard)
@Controller('plantacoes')
export class PlantacoesController {
    constructor(
        private readonly plantacoesService: PlantacoesService,
    ) {}

    @Post()
    create(
        @Body() dto: CreatePlantacaoDto,
        @Request() req,
    ) {
        return this.plantacoesService.create(
        dto,
        req.user.userId,
        );
    }

    @Get()
    findAll(
        @Request() req,
    ) {
        return this.plantacoesService.findAllByUser(
        req.user.userId,
        );
    }

    @Post('update/:codigoPlantacao')
    updateByCodigoPlantacao(
        @Param('codigoPlantacao') codigoPlantacao: string,
        @Body() dto: CreatePlantacaoDto,
        @Request() req,
    ) {
        return this.plantacoesService.updateByCodigoPlantacao(
        codigoPlantacao,
        dto,
        req.user.userId,
        );
    }

    @Delete('delete/:codigoPlantacao')
    deleteByCodigoPlantacao(
        @Param('codigoPlantacao') codigoPlantacao: string,
        @Request() req,
    ) {
        return this.plantacoesService.deleteByCodigoPlantacao(
        codigoPlantacao,
        req.user.userId,
        );
    }

    @Get('historico')
    getHistorico(
        @Request() req,
        //@Query() filters: HistoricoPlantacaoDto,
    ) {
        return this.plantacoesService.getHistoricoCompleto(
        req.user.userId,
        //filters,
        );
    }
}
