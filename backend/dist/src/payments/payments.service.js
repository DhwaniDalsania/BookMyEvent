"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.PaymentsService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
const bookings_service_1 = require("../bookings/bookings.service");
const notifications_service_1 = require("../notifications/notifications.service");
const crypto = __importStar(require("crypto"));
const razorpay_1 = __importDefault(require("razorpay"));
let PaymentsService = class PaymentsService {
    prisma;
    bookingsService;
    notificationsService;
    razorpay;
    constructor(prisma, bookingsService, notificationsService) {
        this.prisma = prisma;
        this.bookingsService = bookingsService;
        this.notificationsService = notificationsService;
        this.razorpay = new razorpay_1.default({
            key_id: process.env.RAZORPAY_KEY_ID || 'dummy_key_id',
            key_secret: process.env.RAZORPAY_KEY_SECRET || 'dummy_key_secret',
        });
    }
    async createOrder(userId, dto) {
        const booking = await this.prisma.booking.findUnique({
            where: { id: dto.bookingId },
        });
        if (!booking)
            throw new common_1.NotFoundException('Booking not found');
        if (booking.userId !== userId)
            throw new common_1.BadRequestException('Not your booking');
        if (booking.status !== 'PENDING')
            throw new common_1.BadRequestException('Booking is not pending');
        const amountInPaise = Math.round(Number(booking.finalAmount) * 100);
        try {
            const order = await this.razorpay.orders.create({
                amount: amountInPaise,
                currency: 'INR',
                receipt: booking.bookingRef,
            });
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
        }
        catch (e) {
            throw new common_1.InternalServerErrorException('Failed to create Razorpay Order');
        }
    }
    async verifyPayment(userId, dto) {
        const payment = await this.prisma.payment.findUnique({
            where: { razorpayOrderId: dto.razorpayOrderId },
        });
        if (!payment)
            throw new common_1.NotFoundException('Payment record not found');
        if (payment.status === 'SUCCESS')
            return { success: true, message: 'Already verified' };
        if (payment.userId !== userId)
            throw new common_1.BadRequestException('Unauthorized');
        const body = dto.razorpayOrderId + '|' + dto.razorpayPaymentId;
        const expectedSignature = crypto
            .createHmac('sha256', process.env.RAZORPAY_KEY_SECRET || 'dummy_key_secret')
            .update(body.toString())
            .digest('hex');
        if (expectedSignature !== dto.razorpaySignature) {
            console.error('--- Signature Verification Mismatch ---');
            console.error('Body (orderId|paymentId):', body);
            console.error('Expected Signature (calculated):', expectedSignature);
            console.error('Received Signature (from client):', dto.razorpaySignature);
            console.error('Loaded secret length:', process.env.RAZORPAY_KEY_SECRET?.length || 0);
            console.error('--------------------------------------');
            throw new common_1.BadRequestException('Invalid Signature');
        }
        await this.prisma.payment.update({
            where: { id: payment.id },
            data: {
                razorpayPaymentId: dto.razorpayPaymentId,
                razorpaySignature: dto.razorpaySignature,
                status: 'SUCCESS',
            },
        });
        await this.bookingsService.confirmBookingAndGenerateTickets(payment.bookingId);
        await this.notificationsService.create(userId, 'PAYMENT', 'Payment Successful', `Your payment of ₹${payment.amount} was successful for booking ${payment.bookingId}. Tickets have been generated!`);
        return { success: true, message: 'Payment verified and booking confirmed' };
    }
    async refundPayment(dto) {
        const payment = await this.prisma.payment.findUnique({
            where: { id: dto.paymentId },
        });
        if (!payment)
            throw new common_1.NotFoundException('Payment not found');
        if (payment.status !== 'SUCCESS' || !payment.razorpayPaymentId)
            throw new common_1.BadRequestException('Can only refund successful payments with valid Razorpay ID');
        try {
            const refundOptions = {};
            if (dto.amount) {
                refundOptions.amount = dto.amount * 100;
            }
            const refund = await this.razorpay.payments.refund(payment.razorpayPaymentId, refundOptions);
            const refundedTotal = Number(payment.refundedAmount) + (refund.amount / 100);
            await this.prisma.payment.update({
                where: { id: payment.id },
                data: {
                    refundedAmount: refundedTotal,
                    status: 'REFUNDED',
                },
            });
            await this.prisma.booking.update({
                where: { id: payment.bookingId },
                data: { status: 'CANCELLED' },
            });
            await this.notificationsService.create(payment.userId, 'REFUND', 'Refund Processed', `A refund of ₹${refund.amount / 100} has been processed for your booking.`);
            return { success: true, refundId: refund.id };
        }
        catch (e) {
            throw new common_1.InternalServerErrorException('Refund failed at Razorpay');
        }
    }
    async handleWebhook(signature, payload) {
        const webhookSecret = process.env.RAZORPAY_WEBHOOK_SECRET || 'dummy_webhook_secret';
        const expectedSignature = crypto
            .createHmac('sha256', webhookSecret)
            .update(JSON.stringify(payload))
            .digest('hex');
        if (expectedSignature !== signature) {
            throw new common_1.BadRequestException('Invalid Webhook Signature');
        }
        const event = payload.event;
        const paymentEntity = payload.payload.payment.entity;
        const payment = await this.prisma.payment.findUnique({
            where: { razorpayOrderId: paymentEntity.order_id },
        });
        if (!payment)
            return { success: true };
        if (event === 'payment.captured' && payment.status !== 'SUCCESS') {
            await this.prisma.payment.update({
                where: { id: payment.id },
                data: {
                    razorpayPaymentId: paymentEntity.id,
                    status: 'SUCCESS',
                    paymentMethod: paymentEntity.method,
                },
            });
            await this.bookingsService.confirmBookingAndGenerateTickets(payment.bookingId);
            await this.notificationsService.create(payment.userId, 'PAYMENT', 'Payment Captured', `Your payment was successfully captured via Webhook.`);
        }
        if (event === 'payment.failed') {
            await this.prisma.payment.update({
                where: { id: payment.id },
                data: { status: 'FAILED' },
            });
            await this.notificationsService.create(payment.userId, 'PAYMENT', 'Payment Failed', `Your payment attempt failed.`);
        }
        return { success: true };
    }
    async findOne(id) {
        return this.prisma.payment.findUnique({ where: { id } });
    }
};
exports.PaymentsService = PaymentsService;
exports.PaymentsService = PaymentsService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService,
        bookings_service_1.BookingsService,
        notifications_service_1.NotificationsService])
], PaymentsService);
//# sourceMappingURL=payments.service.js.map