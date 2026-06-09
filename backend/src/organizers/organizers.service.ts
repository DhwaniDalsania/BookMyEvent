import {
  Injectable,
  NotFoundException,
  ConflictException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateOrganizerDto, UpdateOrganizerDto } from './dto/organizer.dto';

@Injectable()
export class OrganizersService {
  constructor(private prisma: PrismaService) {}

  async create(createOrganizerDto: CreateOrganizerDto) {
    const existing = await this.prisma.organizer.findUnique({
      where: { userId: createOrganizerDto.userId },
    });
    if (existing) {
      throw new ConflictException('User already has an organizer profile');
    }
    return this.prisma.organizer.create({
      data: createOrganizerDto,
    });
  }

  findAll() {
    return this.prisma.organizer.findMany();
  }

  async findOne(id: string) {
    const organizer = await this.prisma.organizer.findUnique({ where: { id } });
    if (!organizer) {
      throw new NotFoundException('Organizer not found');
    }
    return organizer;
  }

  async findOneByUserId(userId: string) {
    const organizer = await this.prisma.organizer.findUnique({
      where: { userId },
    });
    if (!organizer) {
      throw new NotFoundException('Organizer not found for this user');
    }
    return organizer;
  }

  async update(id: string, updateOrganizerDto: UpdateOrganizerDto) {
    await this.findOne(id);
    return this.prisma.organizer.update({
      where: { id },
      data: updateOrganizerDto,
    });
  }

  async remove(id: string) {
    await this.findOne(id);
    return this.prisma.organizer.delete({
      where: { id },
    });
  }

  async getEvents(organizerId: string) {
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

  async getEventsByUserId(userId: string) {
    const organizer = await this.findOneByUserId(userId);
    return this.getEvents(organizer.id);
  }

  async getStatsByUserId(userId: string) {
    const organizer = await this.findOneByUserId(userId);
    const events = await this.prisma.event.findMany({
      where: { organizerId: organizer.id },
      include: { metrics: true },
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
}
