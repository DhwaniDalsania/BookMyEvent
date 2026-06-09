import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  UseGuards,
  Request,
} from '@nestjs/common';
import { OrganizersService } from './organizers.service';
import { CreateOrganizerDto, UpdateOrganizerDto } from './dto/organizer.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard } from '../auth/roles.guard';
import { Roles } from '../auth/roles.decorator';
import type { AuthenticatedRequest } from '../auth/authenticated-request.interface';

@Controller('organizers')
export class OrganizersController {
  constructor(private readonly organizersService: OrganizersService) {}

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('ADMIN', 'ORGANIZER')
  @Post()
  create(
    @Body() createOrganizerDto: CreateOrganizerDto,
    @Request() req: AuthenticatedRequest,
  ) {
    // If not admin, force the userId to be the logged-in user
    if (req.user.role !== 'ADMIN') {
      createOrganizerDto.userId = req.user.userId;
    }
    return this.organizersService.create(createOrganizerDto);
  }

  @Get()
  findAll() {
    return this.organizersService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.organizersService.findOne(id);
  }

  @Get(':id/events')
  getEvents(@Param('id') id: string) {
    return this.organizersService.getEvents(id);
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('ADMIN', 'ORGANIZER')
  @Patch(':id')
  update(
    @Param('id') id: string,
    @Body() updateOrganizerDto: UpdateOrganizerDto,
  ) {
    return this.organizersService.update(id, updateOrganizerDto);
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('ADMIN')
  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.organizersService.remove(id);
  }
}
