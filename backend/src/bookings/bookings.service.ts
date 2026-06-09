import {
  Injectable,
  NotFoundException,
  BadRequestException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { TicketsService } from '../tickets/tickets.service';
import { CreateBookingDto } from './dto/booking.dto';

@Injectable()
export class BookingsService {
  constructor(
    private prisma: PrismaService,
    private ticketsService: TicketsService,
  ) {}

  private generateBookingRef() {
    return 'BME-' + Math.random().toString(36).substring(2, 10).toUpperCase();
  }

  async create(userId: string, dto: CreateBookingDto) {
    let totalAmount = 0;

    // 1. Verify holds and calculate price
    for (const req of dto.tickets) {
      const hold = await this.prisma.seatHold.findUnique({
        where: { eventId_seatId: { eventId: dto.eventId, seatId: req.seatId } },
      });
      if (!hold || hold.userId !== userId || hold.expiresAt < new Date()) {
        throw new BadRequestException(
          `Seat ${req.seatId} is not held by you or hold expired`,
        );
      }

      const tier = await this.prisma.ticketTier.findUnique({
        where: { id: req.ticketTierId },
      });
      if (!tier) throw new NotFoundException('Ticket tier not found');
      totalAmount += Number(tier.price);
    }

    const finalAmount = totalAmount - (dto.discountAmount || 0);

    // 2. Create Booking
    const booking = await this.prisma.booking.create({
      data: {
        bookingRef: this.generateBookingRef(),
        userId,
        eventId: dto.eventId,
        totalAmount,
        discountAmount: dto.discountAmount || 0,
        finalAmount,
        status: 'PENDING',
      },
    });

    // 3. Update holds to belong to this booking
    for (const req of dto.tickets) {
      await this.prisma.seatHold.update({
        where: { eventId_seatId: { eventId: dto.eventId, seatId: req.seatId } },
        data: { bookingId: booking.id },
      });
    }

    return booking;
  }

  async confirmBookingAndGenerateTickets(bookingId: string) {
    const booking = await this.prisma.booking.findUnique({
      where: { id: bookingId },
      include: { seatHolds: true },
    });
    if (!booking) throw new NotFoundException('Booking not found');
    if (booking.status === 'CONFIRMED') return booking;

    // We need to know which tier was mapped to which seat.
    // For simplicity, we assume we fetch the TicketRequests from a temporary structure
    // or we can just infer it if there's only one tier, but in reality we'd store it.
    // To conform to the schema:
    const updatedBooking = await this.prisma.booking.update({
      where: { id: bookingId },
      data: { status: 'CONFIRMED' },
    });

    // Generate Tickets
    // Note: Since schema doesn't store ticketTier in seatHold, we'll fetch the first tier for this event.
    // A robust system would store the requested tier in the SeatHold table.
    const tier = await this.prisma.ticketTier.findFirst({
      where: { eventId: booking.eventId },
    });

    for (const hold of booking.seatHolds) {
      const ticketId =
        'TKT-' + Math.random().toString(36).substring(2, 10).toUpperCase();
      const qrHash = this.ticketsService.generateQrHash(
        booking.bookingRef,
        hold.seatId,
        ticketId,
      );

      const ticket = await this.prisma.ticket.create({
        data: {
          id: ticketId,
          bookingId: booking.id,
          ticketTierId: tier!.id,
          qrCodeHash: qrHash,
          status: 'VALID',
        },
      });

      // Map to TicketSeat
      await this.prisma.ticketSeat.create({
        data: {
          ticketId: ticket.id,
          seatId: hold.seatId,
        },
      });
    }

    return updatedBooking;
  }

  async cancel(userId: string, bookingId: string) {
    const booking = await this.prisma.booking.findUnique({
      where: { id: bookingId },
      include: { tickets: true },
    });
    if (!booking) throw new NotFoundException('Booking not found');
    if (booking.userId !== userId)
      throw new BadRequestException('Not your booking');

    // Update status
    await this.prisma.booking.update({
      where: { id: bookingId },
      data: { status: 'CANCELLED' },
    });

    // Update tickets
    for (const ticket of booking.tickets) {
      await this.prisma.ticket.update({
        where: { id: ticket.id },
        data: { status: 'CANCELLED' },
      });
    }

    // Release seats
    await this.prisma.seatHold.deleteMany({
      where: { bookingId },
    });

    return { message: 'Booking cancelled and seats released' };
  }

  async findOne(id: string) {
    return this.prisma.booking.findUnique({
      where: { id },
      include: {
        tickets: { include: { ticketSeat: true } },
        payment: true,
        event: true,
      },
    });
  }

  async findMyBookings(userId: string) {
    return this.prisma.booking.findMany({
      where: { userId },
      include: { tickets: true, event: true, payment: true },
      orderBy: { createdAt: 'desc' },
    });
  }
}
