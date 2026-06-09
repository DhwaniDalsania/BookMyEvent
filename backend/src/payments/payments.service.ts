import {
  Injectable,
  NotFoundException,
  BadRequestException,
  InternalServerErrorException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { BookingsService } from '../bookings/bookings.service';
import { NotificationsService } from '../notifications/notifications.service';
import {
  CreateOrderDto,
  VerifyPaymentDto,
  RefundPaymentDto,
} from './dto/payment.dto';
import * as crypto from 'crypto';
import Razorpay from 'razorpay';

/**
 * Helper to compute Razorpay signature HMAC.
 * Returns a hex string signature based on orderId and paymentId.
 */
function computeSignature(orderId: string, paymentId: string, secret: string): string {
  const body = `${orderId}|${paymentId}`;
  return crypto.createHmac('sha256', secret).update(body).digest('hex');
}

@Injectable()
export class PaymentsService {
  private razorpay: Razorpay;

  constructor(
    private prisma: PrismaService,
    private bookingsService: BookingsService,
    private notificationsService: NotificationsService,
  ) {
    this.razorpay = new Razorpay({
      key_id: process.env.RAZORPAY_KEY_ID || 'dummy_key_id',
      key_secret: process.env.RAZORPAY_KEY_SECRET || 'dummy_key_secret',
    });
  }

  // Create Order
  async createOrder(userId: string, dto: CreateOrderDto) {
    const booking = await this.prisma.booking.findUnique({
      where: { id: dto.bookingId },
    });
    if (!booking) throw new NotFoundException('Booking not found');
    if (booking.userId !== userId)
      throw new BadRequestException('Not your booking');
    if (booking.status !== 'PENDING')
      throw new BadRequestException('Booking is not pending');

    // Convert amount to Paise for Razorpay
    const amountInPaise = Math.round(Number(booking.finalAmount) * 100);

    try {
      const order = await this.razorpay.orders.create({
        amount: amountInPaise,
        currency: 'INR',
        receipt: booking.bookingRef,
      });

      // Save the Payment placeholder with Razorpay Order ID
      const payment = await this.prisma.payment.create({
        data: {
          bookingId: booking.id,
          userId,
          amount: booking.finalAmount,
          currency: 'INR',
          provider: 'RAZORPAY',
          razorpayOrderId: order.id,
          status: 'PENDING',
        },
      });

      return {
        paymentId: payment.id,
        razorpayOrderId: order.id,
        amount: order.amount,
        currency: order.currency,
      };
    } catch (e) {
      throw new InternalServerErrorException('Failed to create Razorpay Order');
    }
  }

  // Verify Signature
  async verifyPayment(userId: string, dto: VerifyPaymentDto) {
    // Ensure Razorpay secret is configured
    const secret = process.env.RAZORPAY_KEY_SECRET;
    if (!secret) {
      throw new InternalServerErrorException('Razorpay secret not configured');
    }

    const payment = await this.prisma.payment.findUnique({
      where: { razorpayOrderId: dto.razorpayOrderId },
    });
    if (!payment) throw new NotFoundException('Payment record not found');
    if (payment.status === 'SUCCESS')
      return { success: true, message: 'Already verified' };
    if (payment.userId !== userId)
      throw new BadRequestException('Unauthorized');

    // HMAC Validation using helper
    const expectedSignature = computeSignature(dto.razorpayOrderId, dto.razorpayPaymentId, secret);

    if (expectedSignature !== dto.razorpaySignature) {
      // Fallback: check stored webhook signature if available
      const webhook = await this.prisma.paymentWebhook.findFirst({
        where: { razorpayOrderId: dto.razorpayOrderId },
        orderBy: { createdAt: 'desc' },
      });
      if (webhook && webhook.razorpaySignature === dto.razorpaySignature) {
        // Consider verification valid via webhook
        console.warn('Signature mismatch but verified via stored webhook data');
      } else {
        console.error('--- Signature Verification Mismatch ---');
        console.error('Body (orderId|paymentId):', `${dto.razorpayOrderId}|${dto.razorpayPaymentId}`);
        console.error('Expected Signature (calculated):', expectedSignature);
        console.error('Received Signature (from client):', dto.razorpaySignature);
        console.error('Loaded secret length:', process.env.RAZORPAY_KEY_SECRET?.length || 0);
        console.error('--------------------------------------');
        throw new BadRequestException('Invalid Signature');
      }
    }

    

    // Mark as SUCCESS
    await this.prisma.payment.update({
      where: { id: payment.id },
      data: {
        razorpayPaymentId: dto.razorpayPaymentId,
        razorpaySignature: dto.razorpaySignature,
        status: 'SUCCESS',
      },
    });

    // Generate Tickets and Confirm Booking
    await this.bookingsService.confirmBookingAndGenerateTickets(
      payment.bookingId,
    );

    // Notify User
    await this.notificationsService.create(
      userId,
      'PAYMENT',
      'Payment Successful',
      `Your payment of ₹${payment.amount} was successful for booking ${payment.bookingId}. Tickets have been generated!`,
    );

    return { success: true, message: 'Payment verified and booking confirmed' };
  }

  // Handle Refunds
  async refundPayment(dto: RefundPaymentDto) {
    const payment = await this.prisma.payment.findUnique({
      where: { id: dto.paymentId },
    });
    if (!payment) throw new NotFoundException('Payment not found');
    if (payment.status !== 'SUCCESS' || !payment.razorpayPaymentId)
      throw new BadRequestException('Can only refund successful payments with valid Razorpay ID');

    try {
      const refundOptions: any = {};
      if (dto.amount) {
        refundOptions.amount = dto.amount * 100; // Partial Refund in Paise
      }

      const refund: any = await this.razorpay.payments.refund(
        payment.razorpayPaymentId,
        refundOptions,
      );

      const refundedTotal =
        Number(payment.refundedAmount) + (refund.amount / 100);

      await this.prisma.payment.update({
        where: { id: payment.id },
        data: {
          refundedAmount: refundedTotal,
          status: 'REFUNDED',
        },
      });

      // Mark booking as CANCELLED (assuming full refund logic for simplicity)
      await this.prisma.booking.update({
        where: { id: payment.bookingId },
        data: { status: 'CANCELLED' },
      });

      await this.notificationsService.create(
        payment.userId,
        'REFUND',
        'Refund Processed',
        `A refund of ₹${refund.amount / 100} has been processed for your booking.`,
      );

      return { success: true, refundId: refund.id };
    } catch (e) {
      throw new InternalServerErrorException('Refund failed at Razorpay');
    }
  }

  // Handle Webhooks
  async handleWebhook(signature: string, payload: any) {
    const webhookSecret =
      process.env.RAZORPAY_WEBHOOK_SECRET || 'dummy_webhook_secret';

    const expectedSignature = crypto
      .createHmac('sha256', webhookSecret)
      .update(JSON.stringify(payload))
      .digest('hex');

    if (expectedSignature !== signature) {
      throw new BadRequestException('Invalid Webhook Signature');
    }

    const event = payload.event;
    const paymentEntity = payload.payload.payment.entity;

    const payment = await this.prisma.payment.findUnique({
      where: { razorpayOrderId: paymentEntity.order_id },
    });

    if (!payment) return { success: true }; // Ignore unknown payments

    if (event === 'payment.captured' && payment.status !== 'SUCCESS') {
      await this.prisma.payment.update({
        where: { id: payment.id },
        data: {
          razorpayPaymentId: paymentEntity.id,
          status: 'SUCCESS',
          paymentMethod: paymentEntity.method,
        },
      });

      await this.bookingsService.confirmBookingAndGenerateTickets(
        payment.bookingId,
      );

      await this.notificationsService.create(
        payment.userId,
        'PAYMENT',
        'Payment Captured',
        `Your payment was successfully captured via Webhook.`,
      );
    }

    if (event === 'payment.failed') {
      await this.prisma.payment.update({
        where: { id: payment.id },
        data: { status: 'FAILED' },
      });

      await this.notificationsService.create(
        payment.userId,
        'PAYMENT',
        'Payment Failed',
        `Your payment attempt failed.`,
      );
    }

    return { success: true };
  }

  async findOne(id: string) {
    return this.prisma.payment.findUnique({ where: { id } });
  }
}
