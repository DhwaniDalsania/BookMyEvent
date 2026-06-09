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
    });
  }
}
