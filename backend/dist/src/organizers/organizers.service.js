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
exports.OrganizersService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
let OrganizersService = class OrganizersService {
    prisma;
    constructor(prisma) {
        this.prisma = prisma;
    }
    async create(createOrganizerDto) {
        const existing = await this.prisma.organizer.findUnique({
            where: { userId: createOrganizerDto.userId },
        });
        if (existing) {
            throw new common_1.ConflictException('User already has an organizer profile');
        }
        return this.prisma.organizer.create({
            data: createOrganizerDto,
        });
    }
    findAll() {
        return this.prisma.organizer.findMany();
    }
    async findOne(id) {
        const organizer = await this.prisma.organizer.findUnique({ where: { id } });
        if (!organizer) {
            throw new common_1.NotFoundException('Organizer not found');
        }
        return organizer;
    }
    async findOneByUserId(userId) {
        const organizer = await this.prisma.organizer.findUnique({
            where: { userId },
        });
        if (!organizer) {
            throw new common_1.NotFoundException('Organizer not found for this user');
        }
        return organizer;
    }
    async update(id, updateOrganizerDto) {
        await this.findOne(id);
        return this.prisma.organizer.update({
            where: { id },
            data: updateOrganizerDto,
        });
    }
    async remove(id) {
        await this.findOne(id);
        return this.prisma.organizer.delete({
            where: { id },
        });
    }
    async getEvents(organizerId) {
        await this.findOne(organizerId);
        return this.prisma.event.findMany({
            where: { organizerId },
            include: {
                ticketTiers: { orderBy: { price: 'asc' } },
                metrics: true,
                venue: true,
                category: true,
            },
            orderBy: { startTime: 'desc' },
        });
    }
    async getEventsByUserId(userId) {
        const organizer = await this.findOneByUserId(userId);
        return this.getEvents(organizer.id);
    }
    async getStatsByUserId(userId) {
        const organizer = await this.findOneByUserId(userId);
        const events = await this.prisma.event.findMany({
            where: { organizerId: organizer.id },
            include: {
                metrics: true,
                ticketTiers: { orderBy: { price: 'asc' } },
                venue: true,
                category: true,
            },
            orderBy: { startTime: 'desc' },
        });
        const bookings = await this.prisma.booking.count({
            where: {
                event: { organizerId: organizer.id },
                status: 'CONFIRMED',
            },
        });
        const revenue = await this.prisma.booking.aggregate({
            where: {
                event: { organizerId: organizer.id },
                status: 'CONFIRMED',
            },
            _sum: { finalAmount: true },
        });
        return {
            organizer,
            eventCount: events.length,
            bookingCount: bookings,
            totalRevenue: Number(revenue._sum.finalAmount ?? 0),
            events,
        };
    }
};
exports.OrganizersService = OrganizersService;
exports.OrganizersService = OrganizersService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], OrganizersService);
//# sourceMappingURL=organizers.service.js.map