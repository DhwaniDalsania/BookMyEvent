import {
  Injectable,
  ConflictException,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class WishlistService {
  constructor(private prisma: PrismaService) {}

  async addEvent(userId: string, eventId: string) {
    // Check if event exists
    const event = await this.prisma.event.findUnique({
      where: { id: eventId },
    });
    if (!event) throw new NotFoundException('Event not found');

    const existing = await this.prisma.wishlist.findUnique({
      where: { userId_eventId: { userId, eventId } },
    });
    if (existing)
      throw new ConflictException('Event is already in your wishlist');

    return this.prisma.wishlist.create({
      data: { userId, eventId },
    });
  }

  async removeEvent(userId: string, eventId: string) {
    const existing = await this.prisma.wishlist.findUnique({
      where: { userId_eventId: { userId, eventId } },
    });
    if (!existing) throw new NotFoundException('Event not in wishlist');

    return this.prisma.wishlist.delete({
      where: { id: existing.id },
    });
  }

  async getUserWishlist(userId: string) {
    return this.prisma.wishlist.findMany({
      where: { userId },
      include: {
        event: {
          include: { category: true, venue: true },
        },
      },
      orderBy: { createdAt: 'desc' },
    });
  }
}
