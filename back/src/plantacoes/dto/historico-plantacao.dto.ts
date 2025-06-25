/* eslint-disable prettier/prettier */
import { IsOptional, IsString, IsDateString } from 'class-validator';

export class HistoricoPlantacaoDto {
    @IsOptional()
    @IsString()
    tipoMonitoramento?: string; // 'doenca' ou 'praga'

    @IsOptional()
    @IsDateString()
    periodoInicial?: string;

    @IsOptional()
    @IsDateString()
    periodoFinal?: string;
}