import {
  Injectable,
  ConflictException,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateSeatHoldDto } from './dto/seat-hold.dto';

@Injectable()
export class SeatHoldsService {
  constructor(private prisma: PrismaService) {}

  async createHold(userId: string, dto: CreateSeatHoldDto) {
    // Check if seat exists
    const seat = await this.prisma.seat.findUnique({
      where: { id: dto.seatId },
    });
    if (!seat) throw new NotFoundException('Seat not found');

    // Clean up expired holds for this seat first
    await this.prisma.seatHold.deleteMany({
      where: {
        eventId: dto.eventId,
        seatId: dto.seatId,
        expiresAt: { lt: new Date() },
      },
    });

    // Check if hold currently exists
    const existingHold = await this.prisma.seatHold.findUnique({
      where: {
        eventId_seatId: { eventId: dto.eventId, seatId: dto.seatId },
      },
    });

    if (existingHold) {
      if (existingHold.userId === userId) {
        // Extend existing hold if it's the same user
        return this.prisma.seatHold.update({
          where: { id: existingHold.id },
          data: { expiresAt: new Date(Date.now() + 10 * 60 * 1000) }, // 10 minutes
        });
      }
      throw new ConflictException('Seat is currently held by another user');
    }

    // Check if seat is already booked (TicketSeat exists for this event)
    const isBooked = await this.prisma.ticketSeat.findFirst({
      where: {
        seatId: dto.seatId,
        ticket: {
          booking: { eventId: dto.eventId, status: { not: 'CANCELLED' } },
        },
      },
    });
    if (isBooked) throw new ConflictException('Seat is already booked');

    // Create hold
    return this.prisma.seatHold.create({
      data: {
        userId,
        eventId: dto.eventId,
        seatId: dto.seatId,
        expiresAt: new Date(Date.now() + 10 * 60 * 1000), // 10 minutes from now
      },
    });
  }

  async removeHold(userId: string, id: string) {
    const hold = await this.prisma.seatHold.findUnique({ where: { id } });
    if (!hold) throw new NotFoundException('Hold not found');
    if (hold.userId !== userId)
      throw new ConflictException('You do not own this hold');

    return this.prisma.seatHold.delete({ where: { id } });
  }

  async getActiveHoldsForEvent(eventId: string) {
    // Only return unexpired holds
    return this.prisma.seatHold.findMany({
      where: {
        eventId,
        expiresAt: { gt: new Date() },
      },
    });
  }
}
