"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
var PaymentsCronService_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.PaymentsCronService = void 0;
const common_1 = require("@nestjs/common");
const schedule_1 = require("@nestjs/schedule");
const prisma_service_1 = require("../prisma/prisma.service");
const bookings_service_1 = require("../bookings/bookings.service");
const razorpay_1 = __importDefault(require("razorpay"));
let PaymentsCronService = PaymentsCronService_1 = class PaymentsCronService {
    prisma;
    bookingsService;
    logger = new common_1.Logger(PaymentsCronService_1.name);
    razorpay;
    constructor(prisma, bookingsService) {
        this.prisma = prisma;
        this.bookingsService = bookingsService;
        this.razorpay = new razorpay_1.default({
            key_id: process.env.RAZORPAY_KEY_ID || 'dummy_key_id',
            key_secret: process.env.RAZORPAY_KEY_SECRET || 'dummy_key_secret',
        });
    }
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
                    const successfulPayment = paymentsResponse.items.find((p) => p.status === 'captured');
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
                    }
                    else {
                        this.logger.warn(`Order ${order.id} is paid but no captured payment found.`);
                    }
                }
                else {
                    this.logger.log(`Booking ${booking.id} order ${order.id} abandoned. Auto-cancelling.`);
                    await this.cancelBooking(booking.id);
                }
            }
            catch (e) {
                this.logger.error(`Error reconciling booking ${booking.id}: ${e.message}`);
            }
        }
    }
    async cancelBooking(bookingId) {
        await this.prisma.booking.update({
            where: { id: bookingId },
            data: { status: 'CANCELLED' },
        });
        await this.prisma.payment.updateMany({
            where: { bookingId, status: 'PENDING' },
            data: { status: 'FAILED' },
        });
    }
};
exports.PaymentsCronService = PaymentsCronService;
__decorate([
    (0, schedule_1.Cron)(schedule_1.CronExpression.EVERY_5_MINUTES),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], PaymentsCronService.prototype, "handlePendingBookings", null);
exports.PaymentsCronService = PaymentsCronService = PaymentsCronService_1 = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService,
        bookings_service_1.BookingsService])
], PaymentsCronService);
//# sourceMappingURL=payments.cron.service.js.map