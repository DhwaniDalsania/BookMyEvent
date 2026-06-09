import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  UseGuards,
  Request,
} from '@nestjs/common';
import { BookingsService } from './bookings.service';
import { CreateBookingDto } from './dto/booking.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard } from '../auth/roles.guard';
import { Roles } from '../auth/roles.decorator';

@Controller('bookings')
@UseGuards(JwtAuthGuard, RolesGuard)
export class BookingsController {
  constructor(private readonly bookingsService: BookingsService) {}

  @Roles('USER', 'ADMIN', 'ORGANIZER')
  @Post()
  create(@Body() createBookingDto: CreateBookingDto, @Request() req: any) {
    return this.bookingsService.create(req.user.userId, createBookingDto);
  }

  @Roles('USER', 'ADMIN', 'ORGANIZER')
  @Get('user/me')
  findMyBookings(@Request() req: any) {
    return this.bookingsService.findMyBookings(req.user.userId);
  }

  @Roles('USER', 'ADMIN', 'ORGANIZER')
  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.bookingsService.findOne(id);
  }

  @Roles('USER', 'ADMIN', 'ORGANIZER')
  @Post(':id/cancel')
  cancel(@Param('id') id: string, @Request() req: any) {
    return this.bookingsService.cancel(req.user.userId, id);
  }

  // Developer Endpoint for Testing Workflow
  @Roles('ADMIN')
  @Post(':id/simulate-payment-success')
  simulatePaymentSuccess(@Param('id') id: string) {
    return this.bookingsService.confirmBookingAndGenerateTickets(id);
  }
}
