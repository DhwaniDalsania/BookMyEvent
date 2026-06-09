import { Controller, Get, UseGuards } from '@nestjs/common';
import { AnalyticsService } from './analytics.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard } from '../auth/roles.guard';
import { Roles } from '../auth/roles.decorator';

@Controller('analytics')
@UseGuards(JwtAuthGuard, RolesGuard)
export class AnalyticsController {
  constructor(private readonly analyticsService: AnalyticsService) {}

  @Roles('ADMIN')
  @Get('dashboard')
  getDashboardMetrics() {
    return this.analyticsService.getDashboardMetrics();
  }

  @Roles('ADMIN')
  @Get('events')
  getTopEvents() {
    return this.analyticsService.getTopEvents();
  }

  @Roles('ADMIN')
  @Get('revenue')
  getRevenueData() {
    return this.analyticsService.getRevenueData();
  }

  @Roles('ADMIN')
  @Get('bookings')
  getBookingsData() {
    return this.analyticsService.getBookingsData();
  }
}
