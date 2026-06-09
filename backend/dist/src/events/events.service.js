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
exports.EventsService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
let EventsService = class EventsService {
    prisma;
    constructor(prisma) {
        this.prisma = prisma;
    }
    slugify(title) {
        return (title
            .toLowerCase()
            .replace(/[^a-z0-9]+/g, '-')
            .replace(/(^-|-$)+/g, '') +
            '-' +
            Date.now());
    }
    async create(createEventDto) {
        const slug = this.slugify(createEventDto.title);
        return this.prisma.event.create({
            data: {
                ...createEventDto,
                slug,
            },
        });
    }
    findAll(query) {
        const { q, city, category, featured, skip, take } = query;
        const where = { status: 'PUBLISHED' };
        if (q) {
            where.title = { contains: q, mode: 'insensitive' };
        }
        if (city) {
            where.venue = { city: { contains: city, mode: 'insensitive' } };
        }
        if (category) {
            where.category = { slug: category };
        }
        if (featured === 'true') {
            where.isFeatured = true;
        }
        return this.prisma.event.findMany({
            where,
            include: {
                category: true,
                venue: true,
                organizer: true,
            },
            skip: skip ? parseInt(skip) : 0,
            take: take ? parseInt(take) : 20,
            orderBy: { startTime: 'asc' },
        });
    }
    async findOne(id) {
        const event = await this.prisma.event.findUnique({
            where: { id },
            include: {
                category: true,
                venue: true,
                organizer: true,
                images: { orderBy: { sortOrder: 'asc' } },
            },
        });
        if (!event)
            throw new common_1.NotFoundException('Event not found');
        return event;
    }
    async findOneBySlug(slug) {
        const event = await this.prisma.event.findUnique({
            where: { slug },
            include: {
                category: true,
                venue: true,
                organizer: true,
                images: { orderBy: { sortOrder: 'asc' } },
            },
        });
        if (!event)
            throw new common_1.NotFoundException('Event not found');
        return event;
    }
    async update(id, updateEventDto) {
        await this.findOne(id);
        return this.prisma.event.update({
            where: { id },
            data: updateEventDto,
        });
    }
    async remove(id) {
        await this.findOne(id);
        return this.prisma.event.delete({ where: { id } });
    }
    async addImage(eventId, dto) {
        await this.findOne(eventId);
        const count = await this.prisma.eventImage.count({ where: { eventId } });
        return this.prisma.eventImage.create({
            data: {
                eventId,
                imageUrl: dto.imageUrl,
                sortOrder: count,
            },
        });
    }
    async removeImage(imageId) {
        return this.prisma.eventImage.delete({ where: { id: imageId } });
    }
};
exports.EventsService = EventsService;
exports.EventsService = EventsService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], EventsService);
//# sourceMappingURL=events.service.js.map