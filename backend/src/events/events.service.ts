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
    const { ticketTiers, ...eventData } = createEventDto;
    const tiers =
      ticketTiers && ticketTiers.length > 0
        ? ticketTiers
        : [{ name: 'General Admission', price: 999, availableQty: 500 }];

    return this.prisma.event.create({
      data: {
        ...eventData,
        slug,
        status: eventData.status ?? 'PUBLISHED',
        ticketTiers: { create: tiers },
      },
      include: {
        category: true,
        venue: true,
        ticketTiers: { orderBy: { price: 'asc' } },
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
        ticketTiers: { orderBy: { price: 'asc' } },
        metrics: true,
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
        ticketTiers: { orderBy: { price: 'asc' } },
        metrics: true,
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
        ticketTiers: { orderBy: { price: 'asc' } },
        metrics: true,
      },
    });
    if (!event) throw new NotFoundException('Event not found');
    return event;
  }

  private async ensureVenueSeating(venueId: string) {
    const seatCount = await this.prisma.seat.count({ where: { venueId } });
    if (seatCount > 0) return;

    const section = await this.prisma.venueSection.create({
      data: {
        venueId,
        name: 'Main Floor',
        type: 'RESERVED',
        capacity: 64,
      },
    });

    const seats: {
      venueId: string;
      sectionId: string;
      rowName: string;
      seatNumber: string;
      seatType: string;
    }[] = [];

    for (let r = 0; r < 8; r++) {
      const rowName = String.fromCharCode(65 + r);
      for (let c = 1; c <= 8; c++) {
        seats.push({
          venueId,
          sectionId: section.id,
          rowName,
          seatNumber: String(c),
          seatType: r < 2 ? 'VIP' : r < 5 ? 'Premium' : 'Standard',
        });
      }
    }

    await this.prisma.seat.createMany({ data: seats });
  }

  async getSeatMap(eventId: string) {
    const event = await this.prisma.event.findUnique({
      where: { id: eventId },
      include: {
        venue: true,
        ticketTiers: { orderBy: { price: 'asc' } },
      },
    });
    if (!event) throw new NotFoundException('Event not found');

    await this.ensureVenueSeating(event.venueId);

    const sections = await this.prisma.venueSection.findMany({
      where: { venueId: event.venueId },
      include: {
        seats: {
          where: { status: 'ACTIVE' },
          orderBy: [{ rowName: 'asc' }, { seatNumber: 'asc' }],
        },
      },
    });

    const bookedSeats = await this.prisma.ticketSeat.findMany({
      where: {
        ticket: {
          booking: { eventId, status: { not: 'CANCELLED' } },
        },
      },
      select: { seatId: true },
    });
    const bookedSeatIds = new Set(bookedSeats.map((s) => s.seatId));

    const holds = await this.prisma.seatHold.findMany({
      where: { eventId, expiresAt: { gt: new Date() } },
    });
    const holdMap = new Map(holds.map((h) => [h.seatId, h]));

    const tiers = event.ticketTiers;
    const tierForRow = (rowName: string) => {
      if (tiers.length === 0) return null;
      if (tiers.length === 1) return tiers[0];
      const rowIndex = rowName.charCodeAt(0) - 65;
      if (rowIndex <= 1) return tiers[tiers.length - 1];
      if (rowIndex <= 4) return tiers.length > 2 ? tiers[1] : tiers[tiers.length - 1];
      return tiers[0];
    };

    const seats = sections.flatMap((section) =>
      section.seats.map((seat) => {
        const tier = tierForRow(seat.rowName);
        const hold = holdMap.get(seat.id);
        let status = 'available';
        if (bookedSeatIds.has(seat.id)) status = 'booked';
        else if (hold) status = 'held';

        return {
          id: seat.id,
          rowName: seat.rowName,
          seatNumber: seat.seatNumber,
          label: `${seat.rowName}${seat.seatNumber}`,
          sectionName: section.name,
          ticketTierId: tier?.id ?? null,
          ticketTierName: tier?.name ?? null,
          price: tier ? Number(tier.price) : 0,
          status,
        };
      }),
    );

    return {
      eventId,
      venueName: event.venue.name,
      rows: 8,
      cols: 8,
      ticketTiers: tiers.map((t) => ({
        id: t.id,
        name: t.name,
        price: Number(t.price),
        availableQty: t.availableQty,
      })),
      seats,
    };
  }

  async update(id: string, updateEventDto: UpdateEventDto) {
    await this.findOne(id);
    const { ticketTiers, ...eventData } = updateEventDto;

    const updatedEvent = await this.prisma.event.update({
      where: { id },
      data: eventData,
    });

    if (ticketTiers && ticketTiers.length > 0) {
      for (const tier of ticketTiers) {
        const existingTier = await this.prisma.ticketTier.findFirst({
          where: { eventId: id, name: tier.name },
        });

        if (existingTier) {
          await this.prisma.ticketTier.update({
            where: { id: existingTier.id },
            data: {
              price: tier.price,
              availableQty: tier.availableQty,
            },
          });
        } else {
          await this.prisma.ticketTier.create({
            data: {
              eventId: id,
              name: tier.name,
              price: tier.price,
              availableQty: tier.availableQty,
            },
          });
        }
      }
    }

    return this.findOne(id);
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
