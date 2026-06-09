import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateVenueDto, UpdateVenueDto } from './dto/venue.dto';

@Injectable()
export class VenuesService {
  constructor(private prisma: PrismaService) {}

  create(createVenueDto: CreateVenueDto) {
    return this.prisma.venue.create({
      data: createVenueDto,
    });
  }

  findAll() {
    return this.prisma.venue.findMany();
  }

  async findOne(id: string) {
    const venue = await this.prisma.venue.findUnique({ where: { id } });
    if (!venue) {
      throw new NotFoundException('Venue not found');
    }
    return venue;
  }

  async update(id: string, updateVenueDto: UpdateVenueDto) {
    await this.findOne(id);
    return this.prisma.venue.update({
      where: { id },
      data: updateVenueDto,
    });
  }

  async remove(id: string) {
    await this.findOne(id);
    return this.prisma.venue.delete({
      where: { id },
    });
  }
}
