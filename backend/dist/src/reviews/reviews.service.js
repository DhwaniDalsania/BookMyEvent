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
exports.ReviewsService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
let ReviewsService = class ReviewsService {
    prisma;
    constructor(prisma) {
        this.prisma = prisma;
    }
    async create(userId, dto) {
        const booking = await this.prisma.booking.findFirst({
            where: {
                userId,
                eventId: dto.eventId,
                status: { in: ['CONFIRMED'] },
            },
        });
        if (!booking) {
            throw new common_1.ForbiddenException('You can only review events you have booked');
        }
        const existing = await this.prisma.review.findUnique({
            where: { userId_eventId: { userId, eventId: dto.eventId } },
        });
        if (existing) {
            throw new common_1.ConflictException('You have already reviewed this event');
        }
        return this.prisma.review.create({
            data: {
                userId,
                eventId: dto.eventId,
                rating: dto.rating,
                comment: dto.comment,
            },
        });
    }
    async update(userId, id, dto) {
        const review = await this.prisma.review.findUnique({ where: { id } });
        if (!review)
            throw new common_1.NotFoundException('Review not found');
        if (review.userId !== userId)
            throw new common_1.ForbiddenException('You can only edit your own reviews');
        return this.prisma.review.update({
            where: { id },
            data: dto,
        });
    }
    async remove(userId, id, userRole) {
        const review = await this.prisma.review.findUnique({ where: { id } });
        if (!review)
            throw new common_1.NotFoundException('Review not found');
        if (userRole !== 'ADMIN' && review.userId !== userId) {
            throw new common_1.ForbiddenException('You can only delete your own reviews');
        }
        return this.prisma.review.delete({ where: { id } });
    }
    async getEventReviews(eventId) {
        return this.prisma.review.findMany({
            where: { eventId },
            include: {
                user: { select: { id: true, firstName: true, lastName: true } },
            },
            orderBy: { createdAt: 'desc' },
        });
    }
};
exports.ReviewsService = ReviewsService;
exports.ReviewsService = ReviewsService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], ReviewsService);
//# sourceMappingURL=reviews.service.js.map