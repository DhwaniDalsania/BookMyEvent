import { TicketsService } from './tickets.service';
import type { AuthenticatedRequest } from '../auth/authenticated-request.interface';
export declare class TicketsController {
    private readonly ticketsService;
    constructor(ticketsService: TicketsService);
    getUserTickets(req: AuthenticatedRequest): Promise<({
        ticketTier: {
            id: string;
            name: string;
            eventId: string;
            sectionId: string | null;
            price: import("@prisma/client/runtime/library").Decimal;
            availableQty: number;
        };
        booking: {
            event: {
                id: string;
                createdAt: Date;
                deletedAt: Date | null;
                slug: string;
                description: string;
                title: string;
                categoryId: string;
                venueId: string;
                organizerId: string;
                startTime: Date;
                endTime: Date;
                status: import("@prisma/client").$Enums.EventStatus;
                heroImageUrl: string;
                isFeatured: boolean;
            };
        } & {
            id: string;
            createdAt: Date;
            userId: string;
            status: import("@prisma/client").$Enums.BookingStatus;
            eventId: string;
            bookingRef: string;
            totalAmount: import("@prisma/client/runtime/library").Decimal;
            discountAmount: import("@prisma/client/runtime/library").Decimal;
            finalAmount: import("@prisma/client/runtime/library").Decimal;
        };
        ticketSeat: ({
            seat: {
                id: string;
                venueId: string;
                status: import("@prisma/client").$Enums.SeatStatus;
                sectionId: string;
                rowName: string;
                seatNumber: string;
                seatType: string;
            };
        } & {
            id: string;
            seatId: string;
            ticketId: string;
        }) | null;
    } & {
        id: string;
        status: import("@prisma/client").$Enums.TicketStatus;
        bookingId: string;
        ticketTierId: string;
        qrCodeHash: string;
    })[]>;
    findOne(id: string): Promise<{
        ticketTier: {
            id: string;
            name: string;
            eventId: string;
            sectionId: string | null;
            price: import("@prisma/client/runtime/library").Decimal;
            availableQty: number;
        };
        booking: {
            event: {
                id: string;
                createdAt: Date;
                deletedAt: Date | null;
                slug: string;
                description: string;
                title: string;
                categoryId: string;
                venueId: string;
                organizerId: string;
                startTime: Date;
                endTime: Date;
                status: import("@prisma/client").$Enums.EventStatus;
                heroImageUrl: string;
                isFeatured: boolean;
            };
        } & {
            id: string;
            createdAt: Date;
            userId: string;
            status: import("@prisma/client").$Enums.BookingStatus;
            eventId: string;
            bookingRef: string;
            totalAmount: import("@prisma/client/runtime/library").Decimal;
            discountAmount: import("@prisma/client/runtime/library").Decimal;
            finalAmount: import("@prisma/client/runtime/library").Decimal;
        };
        ticketSeat: ({
            seat: {
                id: string;
                venueId: string;
                status: import("@prisma/client").$Enums.SeatStatus;
                sectionId: string;
                rowName: string;
                seatNumber: string;
                seatType: string;
            };
        } & {
            id: string;
            seatId: string;
            ticketId: string;
        }) | null;
    } & {
        id: string;
        status: import("@prisma/client").$Enums.TicketStatus;
        bookingId: string;
        ticketTierId: string;
        qrCodeHash: string;
    }>;
}
