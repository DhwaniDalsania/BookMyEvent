import {
  Injectable,
  ConflictException,
  ForbiddenException,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateReviewDto, UpdateReviewDto } from './dto/review.dto';

@Injectable()
export class ReviewsService {
  constructor(private prisma: PrismaService) {}

  async create(userId: string, dto: CreateReviewDto) {
    // 1. Check if user actually booked this event
    const booking = await this.prisma.booking.findFirst({
      where: {
        userId,
        eventId: dto.eventId,
        status: { in: ['CONFIRMED'] },
      },
    });
    if (!booking) {
      throw new ForbiddenException(
        'You can only review events you have booked',
      );
    }

    // 2. Check if already reviewed
    const existing = await this.prisma.review.findUnique({
      where: { userId_eventId: { userId, eventId: dto.eventId } },
    });
    if (existing) {
      throw new ConflictException('You have already reviewed this event');
    }

    return this.prisma.review.create({
      data: {
        userId,
        eventId: dto.eventId,
        rating: dto.rating,
        comment: dto.comment,
      },
    });
  }

  async update(userId: string, id: string, dto: UpdateReviewDto) {
    const review = await this.prisma.review.findUnique({ where: { id } });
    if (!review) throw new NotFoundException('Review not found');
    if (review.userId !== userId)
      throw new ForbiddenException('You can only edit your own reviews');

    return this.prisma.review.update({
      where: { id },
      data: dto,
    });
  }

  async remove(userId: string, id: string, userRole: string) {
    const review = await this.prisma.review.findUnique({ where: { id } });
    if (!review) throw new NotFoundException('Review not found');

    if (userRole !== 'ADMIN' && review.userId !== userId) {
      throw new ForbiddenException('You can only delete your own reviews');
    }

    return this.prisma.review.delete({ where: { id } });
  }

  async getEventReviews(eventId: string) {
    return this.prisma.review.findMany({
      where: { eventId },
      include: {
        user: { select: { id: true, firstName: true, lastName: true } },
      },
      orderBy: { createdAt: 'desc' },
    });
  }
}
