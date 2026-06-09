import { SeatHoldsService } from './seat-holds.service';
import { CreateSeatHoldDto } from './dto/seat-hold.dto';
import type { AuthenticatedRequest } from '../auth/authenticated-request.interface';
export declare class SeatHoldsController {
    private readonly seatHoldsService;
    constructor(seatHoldsService: SeatHoldsService);
    create(createSeatHoldDto: CreateSeatHoldDto, req: AuthenticatedRequest): Promise<{
        id: string;
        userId: string;
        eventId: string;
        seatId: string;
        bookingId: string | null;
        expiresAt: Date;
    }>;
    remove(id: string, req: AuthenticatedRequest): Promise<{
        id: string;
        userId: string;
        eventId: string;
        seatId: string;
        bookingId: string | null;
        expiresAt: Date;
    }>;
    getEventHolds(eventId: string): Promise<{
        id: string;
        userId: string;
        eventId: string;
        seatId: string;
        bookingId: string | null;
        expiresAt: Date;
    }[]>;
}
