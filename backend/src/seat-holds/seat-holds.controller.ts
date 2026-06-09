import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  Delete,
  UseGuards,
  Request,
} from '@nestjs/common';
import { SeatHoldsService } from './seat-holds.service';
import { CreateSeatHoldDto } from './dto/seat-hold.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard } from '../auth/roles.guard';
import { Roles } from '../auth/roles.decorator';
import type { AuthenticatedRequest } from '../auth/authenticated-request.interface';

@Controller('seat-holds')
export class SeatHoldsController {
  constructor(private readonly seatHoldsService: SeatHoldsService) {}

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('USER', 'ADMIN', 'ORGANIZER')
  @Post()
  create(
    @Body() createSeatHoldDto: CreateSeatHoldDto,
    @Request() req: AuthenticatedRequest,
  ) {
    return this.seatHoldsService.createHold(req.user.userId, createSeatHoldDto);
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('USER', 'ADMIN', 'ORGANIZER')
  @Delete(':id')
  remove(@Param('id') id: string, @Request() req: AuthenticatedRequest) {
    return this.seatHoldsService.removeHold(req.user.userId, id);
  }

  @Get('event/:eventId')
  getEventHolds(@Param('eventId') eventId: string) {
    return this.seatHoldsService.getActiveHoldsForEvent(eventId);
  }
}
