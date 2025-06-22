/* eslint-disable prettier/prettier */
import { Controller, Get } from '@nestjs/common';
import { DashboardService } from './services/dashboard.service';

@Controller('dashboard')
export class DashboardController {
  constructor(private readonly dashboardService: DashboardService) {}

  @Get()
  async getData() {
    return this.dashboardService.getDashboardData();
  }
}