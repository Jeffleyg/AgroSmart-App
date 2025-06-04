/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable prettier/prettier */
import { Injectable } from '@nestjs/common';
import { HttpService } from '@nestjs/axios';
import { firstValueFrom } from 'rxjs';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class ClimaFetcherService {
    constructor(
        private httpService: HttpService,
        private configService: ConfigService,
    ) {}

    async getClimaData() {
        const response = await firstValueFrom(
        this.httpService.get('https://api.openweathermap.org/data/2.5/weather', {
            params: {
            lat: this.configService.get('DEFAULT_LAT'),
            lon: this.configService.get('DEFAULT_LON'),
            appid: this.configService.get('OPENWEATHER_API_KEY'),
            units: 'metric',
            lang: 'pt',
            },
        }),
        );

        return {
        temperatura: response.data.main.temp,
        condicao: response.data.weather[0].description,
        umidade: response.data.main.humidity,
        };
    }
}