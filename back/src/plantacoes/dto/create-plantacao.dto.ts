/* eslint-disable @typescript-eslint/no-unsafe-call */
/* eslint-disable prettier/prettier */
import { Type } from 'class-transformer';
import { IsString, IsDate } from 'class-validator';

export class CreatePlantacaoDto {
    @IsString()
    nome: string;

    @IsString()
    codigoPlantacao: string;

    @IsString()
    tipoCultura: string;

    @Type(() => Date)
    @IsDate()
    dataInicioPlantio: Date;

    @Type(() => Date)
    @IsDate()
    dataPrevisaoColheita: Date;

    @Type(() => Date)
    @IsDate()
    dataPlantio: Date;
}
