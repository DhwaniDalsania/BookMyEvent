import { PrismaService } from '../prisma/prisma.service';
import { CreateSeatHoldDto } from './dto/seat-hold.dto';
export declare class SeatHoldsService {
    private prisma;
    constructor(prisma: PrismaService);
    createHold(userId: string, dto: CreateSeatHoldDto): Promise<{
        id: string;
        userId: string;
        eventId: string;
        bookingId: string | null;
        seatId: string;
        expiresAt: Date;
    }>;
    removeHold(userId: string, id: string): Promise<{
        id: string;
        userId: string;
        eventId: string;
        bookingId: string | null;
        seatId: string;
        expiresAt: Date;
    }>;
    getActiveHoldsForEvent(eventId: string): Promise<{
        id: string;
        userId: string;
        eventId: string;
        bookingId: string | null;
        seatId: string;
        expiresAt: Date;
    }[]>;
}
