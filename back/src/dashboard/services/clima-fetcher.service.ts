/* eslint-disable @typescript-eslint/no-unsafe-call */
/* eslint-disable @typescript-eslint/no-unsafe-return */
/* eslint-disable @typescript-eslint/no-unsafe-member-access */
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
    async getGeolocation(): Promise<{ lat: number; lon: number }> {
        const response = await firstValueFrom(
            this.httpService.get('https://ipinfo.io/json', {
                params: { token: this.configService.get('IPINFO_TOKEN') }
            })
            );

        const [lat, lon] = response.data.loc.split(',');
        return { lat: parseFloat(lat), lon: parseFloat(lon) };

    }



    async getClimaData() {

        const { lat, lon } = await this.getGeolocation();


        const response = await firstValueFrom(
        this.httpService.get('https://api.openweathermap.org/data/2.5/weather', {
            params: {
            lat,
            lon,
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
        icon: response.data.weather[0].icon,
        };
    }

    async getPrevisao14Dias(cidade: string = 'São Paulo') {
    const response = await firstValueFrom(
        this.httpService.get('https://api.tomorrow.io/v4/weather/forecast', {
            params: {
            location: cidade,
            timesteps: '1d',
            units: 'metric',
            apikey: this.configService.get('TOMORROW_API_KEY'),
            },
        }),
        );

        const dados = response.data.timelines.daily;

        return dados.map((dia) => ({
        data: dia.time,
        temperaturaMin: dia.values.temperatureMin,
        temperaturaMax: dia.values.temperatureMax,
        condicao: dia.values.weatherCode,
        chuva: dia.values.precipitationProbabilityAvg,
        }));
    }
}