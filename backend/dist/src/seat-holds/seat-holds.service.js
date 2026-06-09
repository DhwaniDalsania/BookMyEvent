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
exports.SeatHoldsService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
let SeatHoldsService = class SeatHoldsService {
    prisma;
    constructor(prisma) {
        this.prisma = prisma;
    }
    async createHold(userId, dto) {
        const seat = await this.prisma.seat.findUnique({
            where: { id: dto.seatId },
        });
        if (!seat)
            throw new common_1.NotFoundException('Seat not found');
        await this.prisma.seatHold.deleteMany({
            where: {
                eventId: dto.eventId,
                seatId: dto.seatId,
                expiresAt: { lt: new Date() },
            },
        });
        const existingHold = await this.prisma.seatHold.findUnique({
            where: {
                eventId_seatId: { eventId: dto.eventId, seatId: dto.seatId },
            },
        });
        if (existingHold) {
            if (existingHold.userId === userId) {
                return this.prisma.seatHold.update({
                    where: { id: existingHold.id },
                    data: { expiresAt: new Date(Date.now() + 10 * 60 * 1000) },
                });
            }
            throw new common_1.ConflictException('Seat is currently held by another user');
        }
        const isBooked = await this.prisma.ticketSeat.findFirst({
            where: {
                seatId: dto.seatId,
                ticket: {
                    booking: { eventId: dto.eventId, status: { not: 'CANCELLED' } },
                },
            },
        });
        if (isBooked)
            throw new common_1.ConflictException('Seat is already booked');
        return this.prisma.seatHold.create({
            data: {
                userId,
                eventId: dto.eventId,
                seatId: dto.seatId,
                expiresAt: new Date(Date.now() + 10 * 60 * 1000),
            },
        });
    }
    async removeHold(userId, id) {
        const hold = await this.prisma.seatHold.findUnique({ where: { id } });
        if (!hold)
            throw new common_1.NotFoundException('Hold not found');
        if (hold.userId !== userId)
            throw new common_1.ConflictException('You do not own this hold');
        return this.prisma.seatHold.delete({ where: { id } });
    }
    async getActiveHoldsForEvent(eventId) {
        return this.prisma.seatHold.findMany({
            where: {
                eventId,
                expiresAt: { gt: new Date() },
            },
        });
    }
};
exports.SeatHoldsService = SeatHoldsService;
exports.SeatHoldsService = SeatHoldsService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], SeatHoldsService);
//# sourceMappingURL=seat-holds.service.js.map