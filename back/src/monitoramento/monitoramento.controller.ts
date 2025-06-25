/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-unsafe-return */
/* eslint-disable @typescript-eslint/no-unsafe-call */
/* eslint-disable @typescript-eslint/require-await */
/* eslint-disable prettier/prettier */
import { Controller, Post, Body, Get, UseGuards, Request } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { MonitoramentoService } from './monitoramento.service';
import { CreateMonitoramentoDto } from './dto/create-monitoramento.dto';

@UseGuards(JwtAuthGuard)
@Controller('monitoramento')
export class MonitoramentoController {
    constructor(private readonly monitoramentoService: MonitoramentoService) {}

    @Post()
    async create(
        @Body() dto: CreateMonitoramentoDto,
        @Request() req,
    ) {
        return this.monitoramentoService.create(dto, req.user.userId);
    }

    @Get('ultimo')
    async getUltimoMonitoramento(@Request() req) {
        return this.monitoramentoService.getUltimoPorUsuario(req.user.userId);
    }

    @Get('historico')
    async getHistorico(@Request() req) {
        console.log('Usuário autenticado:', req.user);
        return this.monitoramentoService.getHistoricoPorUsuario(req.user.userId);
    }
}