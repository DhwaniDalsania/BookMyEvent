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
import { ReviewsService } from './reviews.service';
import { CreateReviewDto, UpdateReviewDto } from './dto/review.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard } from '../auth/roles.guard';
import { Roles } from '../auth/roles.decorator';
import type { AuthenticatedRequest } from '../auth/authenticated-request.interface';

@Controller('reviews')
export class ReviewsController {
  constructor(private readonly reviewsService: ReviewsService) {}

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('USER', 'ADMIN', 'ORGANIZER')
  @Post()
  create(
    @Body() createReviewDto: CreateReviewDto,
    @Request() req: AuthenticatedRequest,
  ) {
    return this.reviewsService.create(req.user.userId, createReviewDto);
  }

  @Get('event/:eventId')
  getEventReviews(@Param('eventId') eventId: string) {
    return this.reviewsService.getEventReviews(eventId);
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('USER', 'ADMIN', 'ORGANIZER')
  @Patch(':id')
  update(
    @Param('id') id: string,
    @Body() updateReviewDto: UpdateReviewDto,
    @Request() req: AuthenticatedRequest,
  ) {
    return this.reviewsService.update(req.user.userId, id, updateReviewDto);
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('USER', 'ADMIN') // Organizers shouldn't delete reviews, only user or admin
  @Delete(':id')
  remove(@Param('id') id: string, @Request() req: AuthenticatedRequest) {
    return this.reviewsService.remove(req.user.userId, id, req.user.role);
  }
}
