import { Controller, Post, Body } from '@nestjs/common';
import { AlertService } from './alert.service';

@Controller('alert')
export class AlertController {
  constructor(private readonly alertService: AlertService) {}

  @Post()
  async sendAlert(@Body('message') message: string, @Body('city') city: string) {
    return {
      status: 'success',
      response: await this.alertService.sendAlert(message || 'Acenda!', city || 'Indefinido'),
    };
  }
}
