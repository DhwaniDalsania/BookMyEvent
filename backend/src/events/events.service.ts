import {
  Injectable,
  NotFoundException,
  ConflictException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import {
  CreateEventDto,
  UpdateEventDto,
  QueryEventDto,
  CreateEventImageDto,
} from './dto/event.dto';

@Injectable()
export class EventsService {
  constructor(private prisma: PrismaService) {}

  private slugify(title: string) {
    return (
      title
        .toLowerCase()
        .replace(/[^a-z0-9]+/g, '-')
        .replace(/(^-|-$)+/g, '') +
      '-' +
      Date.now()
    );
  }

  async create(createEventDto: CreateEventDto) {
    const slug = this.slugify(createEventDto.title);
    return this.prisma.event.create({
      data: {
        ...createEventDto,
        slug,
      },
    });
  }

  findAll(query: QueryEventDto) {
    const { q, city, category, featured, skip, take } = query;
    const where: any = { status: 'PUBLISHED' };

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

  async findOne(id: string) {
    const event = await this.prisma.event.findUnique({
      where: { id },
      include: {
        category: true,
        venue: true,
        organizer: true,
        images: { orderBy: { sortOrder: 'asc' } },
      },
    });
    if (!event) throw new NotFoundException('Event not found');
    return event;
  }

  async findOneBySlug(slug: string) {
    const event = await this.prisma.event.findUnique({
      where: { slug },
      include: {
        category: true,
        venue: true,
        organizer: true,
        images: { orderBy: { sortOrder: 'asc' } },
      },
    });
    if (!event) throw new NotFoundException('Event not found');
    return event;
  }

  async update(id: string, updateEventDto: UpdateEventDto) {
    await this.findOne(id);
    return this.prisma.event.update({
      where: { id },
      data: updateEventDto,
    });
  }

  async remove(id: string) {
    await this.findOne(id);
    return this.prisma.event.delete({ where: { id } });
  }

  async addImage(eventId: string, dto: CreateEventImageDto) {
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

  async removeImage(imageId: string) {
    return this.prisma.eventImage.delete({ where: { id: imageId } });
  }
}
