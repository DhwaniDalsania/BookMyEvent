import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import * as crypto from 'crypto';

@Injectable()
export class TicketsService {
  constructor(private prisma: PrismaService) {}

  generateQrHash(bookingRef: string, seatId: string, uuid: string) {
    // Generate secure, unique, non-guessable hash for QR
    const data = `${bookingRef}-${seatId}-${uuid}-${process.env.JWT_SECRET}`;
    return crypto.createHash('sha256').update(data).digest('hex');
  }

  async findOne(id: string) {
    const ticket = await this.prisma.ticket.findUnique({
      where: { id },
      include: {
        booking: { include: { event: true } },
        ticketTier: true,
        ticketSeat: { include: { seat: true } },
      },
    });
    if (!ticket) throw new NotFoundException('Ticket not found');
    return ticket;
  }

  async findByUserId(userId: string) {
    return this.prisma.ticket.findMany({
      where: {
        booking: { userId },
      },
      include: {
        booking: { include: { event: true } },
        ticketTier: true,
        ticketSeat: { include: { seat: true } },
      },
      orderBy: { booking: { createdAt: 'desc' } },
    });
  }
}
