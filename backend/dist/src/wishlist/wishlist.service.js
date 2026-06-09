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
exports.WishlistService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
let WishlistService = class WishlistService {
    prisma;
    constructor(prisma) {
        this.prisma = prisma;
    }
    async addEvent(userId, eventId) {
        const event = await this.prisma.event.findUnique({
            where: { id: eventId },
        });
        if (!event)
            throw new common_1.NotFoundException('Event not found');
        const existing = await this.prisma.wishlist.findUnique({
            where: { userId_eventId: { userId, eventId } },
        });
        if (existing)
            throw new common_1.ConflictException('Event is already in your wishlist');
        return this.prisma.wishlist.create({
            data: { userId, eventId },
        });
    }
    async removeEvent(userId, eventId) {
        const existing = await this.prisma.wishlist.findUnique({
            where: { userId_eventId: { userId, eventId } },
        });
        if (!existing)
            throw new common_1.NotFoundException('Event not in wishlist');
        return this.prisma.wishlist.delete({
            where: { id: existing.id },
        });
    }
    async getUserWishlist(userId) {
        return this.prisma.wishlist.findMany({
            where: { userId },
            include: {
                event: {
                    include: { category: true, venue: true },
                },
            },
            orderBy: { createdAt: 'desc' },
        });
    }
};
exports.WishlistService = WishlistService;
exports.WishlistService = WishlistService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], WishlistService);
//# sourceMappingURL=wishlist.service.js.map