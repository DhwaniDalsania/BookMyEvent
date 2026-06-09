import { Controller, Get, Param, UseGuards, Request } from '@nestjs/common';
import { TicketsService } from './tickets.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import type { AuthenticatedRequest } from '../auth/authenticated-request.interface';
import { RolesGuard } from '../auth/roles.guard';
import { Roles } from '../auth/roles.decorator';

@Controller('tickets')
@UseGuards(JwtAuthGuard, RolesGuard)
export class TicketsController {
  constructor(private readonly ticketsService: TicketsService) {}

  @Roles('USER', 'ADMIN', 'ORGANIZER')
  @Get('user/me')
  getUserTickets(@Request() req: AuthenticatedRequest) {
    return this.ticketsService.findByUserId(req.user.userId);
  }

  @Roles('USER', 'ADMIN', 'ORGANIZER')
  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.ticketsService.findOne(id);
  }
}
