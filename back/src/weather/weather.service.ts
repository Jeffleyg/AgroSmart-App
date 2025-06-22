import { Injectable } from '@nestjs/common';
import { HttpService } from '@nestjs/axios';
import { ConfigService } from '@nestjs/config';
import { firstValueFrom } from 'rxjs';
import { AlertService } from '../alert/alert.service';

@Injectable()
export class WeatherService {
  private readonly BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';

  constructor(
    private readonly httpService: HttpService,
    private readonly configService: ConfigService,
    private readonly alertService: AlertService,
  ) {}

  // ✅ nome atualizado para bater com o controller
  async getWeatherAndCheckAlert(city: string): Promise<any> {
    const apiKey = this.configService.get<string>('OPENWEATHER_API_KEY');
    const url = `${this.BASE_URL}?q=${city}&appid=${apiKey}&units=metric&lang=pt`;

    const { data } = await firstValueFrom(this.httpService.get(url));
    const temperature = data.main.temp;
    const weatherDesc = data.weather[0].description.toLowerCase();

    // 🔹 Alerta de frio
    if (temperature < 15) {
      await this.alertService.sendAlert(
        `⚠️ Alerta: previsão de frio intenso (temperatura de ${temperature}°C) em ${city}.`,
        city,
      );
    }

    // 🔹 Alerta de chuva
    if (weatherDesc.includes('chuva')) {
      await this.alertService.sendAlert(
        `⚠️ Alerta: previsão de chuva em ${city}.`,
        city,
      );
    }

    return data;
  }
}
