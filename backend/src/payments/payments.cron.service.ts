import { Injectable, Logger } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { PrismaService } from '../prisma/prisma.service';
import { BookingsService } from '../bookings/bookings.service';
import Razorpay from 'razorpay';

@Injectable()
export class PaymentsCronService {
  private readonly logger = new Logger(PaymentsCronService.name);
  private razorpay: Razorpay;

  constructor(
    private prisma: PrismaService,
    private bookingsService: BookingsService,
  ) {
    this.razorpay = new Razorpay({
      key_id: process.env.RAZORPAY_KEY_ID || 'dummy_key_id',
      key_secret: process.env.RAZORPAY_KEY_SECRET || 'dummy_key_secret',
    });
  }

  @Cron(CronExpression.EVERY_5_MINUTES)
  async handlePendingBookings() {
    this.logger.log('Running payment reconciliation cron job...');

    const thirtyMinutesAgo = new Date(Date.now() - 30 * 60 * 1000);

    const staleBookings = await this.prisma.booking.findMany({
      where: {
        status: 'PENDING',
        createdAt: {
          lt: thirtyMinutesAgo,
        },
      },
      include: { payment: true },
    });

    for (const booking of staleBookings) {
      try {
        const payment = booking.payment;

        if (!payment || !payment.razorpayOrderId) {
          this.logger.warn(`Booking ${booking.id} has no Razorpay order. Cancelling.`);
          await this.cancelBooking(booking.id);
          continue;
        }

        if (payment.status !== 'PENDING') {
           continue; 
        }

        const order = await this.razorpay.orders.fetch(payment.razorpayOrderId);

        if (order.status === 'paid') {
          this.logger.log(`Booking ${booking.id} order ${order.id} is paid. Auto-confirming.`);
          
          const paymentsResponse = await this.razorpay.orders.fetchPayments(order.id);
          const successfulPayment = paymentsResponse.items.find((p: any) => p.status === 'captured');
          
          if (successfulPayment) {
            await this.prisma.payment.update({
              where: { id: payment.id },
              data: {
                status: 'SUCCESS',
                razorpayPaymentId: successfulPayment.id,
                paymentMethod: successfulPayment.method,
              },
            });
            await this.bookingsService.confirmBookingAndGenerateTickets(booking.id);
          } else {
             this.logger.warn(`Order ${order.id} is paid but no captured payment found.`);
          }
        } else {
          this.logger.log(`Booking ${booking.id} order ${order.id} abandoned. Auto-cancelling.`);
          await this.cancelBooking(booking.id);
        }

      } catch (e: any) {
        this.logger.error(`Error reconciling booking ${booking.id}: ${e.message}`);
      }
    }
  }

  private async cancelBooking(bookingId: string) {
    await this.prisma.booking.update({
      where: { id: bookingId },
      data: { status: 'CANCELLED' },
    });
    
    await this.prisma.payment.updateMany({
      where: { bookingId, status: 'PENDING' },
      data: { status: 'FAILED' },
    });
  }
}
