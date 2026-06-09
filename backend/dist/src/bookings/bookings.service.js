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
Object.defineProperty(exports, "__esModule", { value: true });
exports.BookingsService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
const tickets_service_1 = require("../tickets/tickets.service");
let BookingsService = class BookingsService {
    prisma;
    ticketsService;
    constructor(prisma, ticketsService) {
        this.prisma = prisma;
        this.ticketsService = ticketsService;
    }
    generateBookingRef() {
        return 'BME-' + Math.random().toString(36).substring(2, 10).toUpperCase();
    }
    async create(userId, dto) {
        let ticketPrice = 0;
        for (const req of dto.tickets) {
            const hold = await this.prisma.seatHold.findUnique({
                where: { eventId_seatId: { eventId: dto.eventId, seatId: req.seatId } },
            });
            if (!hold || hold.userId !== userId || hold.expiresAt < new Date()) {
                throw new common_1.BadRequestException(`Seat ${req.seatId} is not held by you or hold expired`);
            }
            const tier = await this.prisma.ticketTier.findUnique({
                where: { id: req.ticketTierId },
            });
            if (!tier)
                throw new common_1.NotFoundException('Ticket tier not found');
            ticketPrice += Number(tier.price);
        }
        const bookingFee = 99.0;
        const platformFee = 49.0;
        const totalAmount = ticketPrice + bookingFee + platformFee;
        const finalAmount = totalAmount - (dto.discountAmount || 0);
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
        for (const req of dto.tickets) {
            await this.prisma.seatHold.update({
                where: { eventId_seatId: { eventId: dto.eventId, seatId: req.seatId } },
                data: { bookingId: booking.id },
            });
        }
        return booking;
    }
    async confirmBookingAndGenerateTickets(bookingId) {
        const booking = await this.prisma.booking.findUnique({
            where: { id: bookingId },
            include: { seatHolds: true },
        });
        if (!booking)
            throw new common_1.NotFoundException('Booking not found');
        if (booking.status === 'CONFIRMED')
            return booking;
        const updatedBooking = await this.prisma.booking.update({
            where: { id: bookingId },
            data: { status: 'CONFIRMED' },
        });
        const tier = await this.prisma.ticketTier.findFirst({
            where: { eventId: booking.eventId },
        });
        for (const hold of booking.seatHolds) {
            const ticketId = 'TKT-' + Math.random().toString(36).substring(2, 10).toUpperCase();
            const qrHash = this.ticketsService.generateQrHash(booking.bookingRef, hold.seatId, ticketId);
            const ticket = await this.prisma.ticket.create({
                data: {
                    id: ticketId,
                    bookingId: booking.id,
                    ticketTierId: tier.id,
                    qrCodeHash: qrHash,
                    status: 'VALID',
                },
            });
            await this.prisma.ticketSeat.create({
                data: {
                    ticketId: ticket.id,
                    seatId: hold.seatId,
                },
            });
        }
        return updatedBooking;
    }
    async cancel(userId, bookingId) {
        const booking = await this.prisma.booking.findUnique({
            where: { id: bookingId },
            include: { tickets: true },
        });
        if (!booking)
            throw new common_1.NotFoundException('Booking not found');
        if (booking.userId !== userId)
            throw new common_1.BadRequestException('Not your booking');
        await this.prisma.booking.update({
            where: { id: bookingId },
            data: { status: 'CANCELLED' },
        });
        for (const ticket of booking.tickets) {
            await this.prisma.ticket.update({
                where: { id: ticket.id },
                data: { status: 'CANCELLED' },
            });
        }
        await this.prisma.seatHold.deleteMany({
            where: { bookingId },
        });
        return { message: 'Booking cancelled and seats released' };
    }
    async findOne(id) {
        return this.prisma.booking.findUnique({
            where: { id },
            include: {
                tickets: { include: { ticketSeat: true } },
                payment: true,
                event: true,
            },
        });
    }
    async findMyBookings(userId) {
        return this.prisma.booking.findMany({
            where: { userId },
            include: { tickets: true, event: true, payment: true },
            orderBy: { createdAt: 'desc' },
        });
    }
};
exports.BookingsService = BookingsService;
exports.BookingsService = BookingsService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService,
        tickets_service_1.TicketsService])
], BookingsService);
//# sourceMappingURL=bookings.service.js.map