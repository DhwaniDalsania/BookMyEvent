import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class AnalyticsService {
  constructor(private prisma: PrismaService) {}

  async getDashboardMetrics() {
    const totalUsers = await this.prisma.user.count({
      where: { role: 'USER' },
    });
    const activeOrganizers = await this.prisma.user.count({
      where: { role: 'ORGANIZER' },
    });
    const totalEvents = await this.prisma.event.count();
    const totalBookings = await this.prisma.booking.count({
      where: { status: 'CONFIRMED' },
    });

    // Summing revenue from payments
    const revenueAggr = await this.prisma.payment.aggregate({
      _sum: { amount: true },
      where: { status: 'SUCCESS' },
    });

    // Summing ticket sales
    const ticketsSold = await this.prisma.ticket.count({
      where: { status: { in: ['VALID', 'SCANNED'] } },
    });

    return {
      totalUsers,
      activeOrganizers,
      totalEvents,
      totalBookings,
      totalRevenue: revenueAggr._sum.amount || 0,
      ticketSales: ticketsSold,
    };
  }

  async getTopEvents() {
    // Find events with most bookings
    return this.prisma.event.findMany({
      take: 10,
      orderBy: {
        bookings: { _count: 'desc' },
      },
      include: {
        _count: { select: { bookings: true } },
      },
    });
  }

  async getRevenueData() {
    // Basic aggregation of successful payments
    const payments = await this.prisma.payment.findMany({
      where: { status: 'SUCCESS' },
      select: { amount: true, createdAt: true },
      orderBy: { createdAt: 'asc' },
    });
    return payments;
  }

  async getBookingsData() {
    const bookings = await this.prisma.booking.findMany({
      select: { status: true, finalAmount: true, createdAt: true },
      orderBy: { createdAt: 'asc' },
    });
    return bookings;
  }
}
