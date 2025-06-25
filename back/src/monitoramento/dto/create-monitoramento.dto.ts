/* eslint-disable prettier/prettier */
import { IsNumber, IsString, IsOptional } from 'class-validator';

export class CreateMonitoramentoDto {
    @IsNumber()
    umidadeSolo: number;

    @IsString()
    estadoPlantas: string;

    @IsString()
    @IsOptional()
    observacoes?: string;

    @IsString()
    plantacaoId: string;
}