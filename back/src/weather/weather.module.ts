import { Module } from '@nestjs/common';
import { HttpModule } from '@nestjs/axios';
import { WeatherService } from './weather.service';
import { WeatherController } from './weather.controller';
import { AlertService } from '../alert/alert.service'; // importa serviço do alerta
import { AlertModule } from  '../alert/alert.module';


@Module({
  imports: [HttpModule, AlertModule],
  controllers: [WeatherController],
  providers: [WeatherService],
}) 
export class WeatherModule {}
