import { TicketsService } from './tickets.service';
import type { AuthenticatedRequest } from '../auth/authenticated-request.interface';
export declare class TicketsController {
    private readonly ticketsService;
    constructor(ticketsService: TicketsService);
    getUserTickets(req: AuthenticatedRequest): Promise<({
        ticketSeat: ({
            seat: {
                id: string;
                venueId: string;
                sectionId: string;
                rowName: string;
                seatNumber: string;
                seatType: string;
                status: import("@prisma/client").$Enums.SeatStatus;
            };
        } & {
            id: string;
            ticketId: string;
            seatId: string;
        }) | null;
        ticketTier: {
            id: string;
            name: string;
            sectionId: string | null;
            price: import("@prisma/client/runtime/library").Decimal;
            availableQty: number;
            eventId: string;
        };
        booking: {
            event: {
                id: string;
                createdAt: Date;
                deletedAt: Date | null;
                description: string;
                slug: string;
                venueId: string;
                status: import("@prisma/client").$Enums.EventStatus;
                title: string;
                categoryId: string;
                organizerId: string;
                startTime: Date;
                endTime: Date;
                heroImageUrl: string;
                isFeatured: boolean;
            };
        } & {
            id: string;
            createdAt: Date;
            userId: string;
            status: import("@prisma/client").$Enums.BookingStatus;
            eventId: string;
            finalAmount: import("@prisma/client/runtime/library").Decimal;
            totalAmount: import("@prisma/client/runtime/library").Decimal;
            discountAmount: import("@prisma/client/runtime/library").Decimal;
            bookingRef: string;
        };
    } & {
        id: string;
        status: import("@prisma/client").$Enums.TicketStatus;
        bookingId: string;
        ticketTierId: string;
        qrCodeHash: string;
    })[]>;
    findOne(id: string): Promise<{
        ticketSeat: ({
            seat: {
                id: string;
                venueId: string;
                sectionId: string;
                rowName: string;
                seatNumber: string;
                seatType: string;
                status: import("@prisma/client").$Enums.SeatStatus;
            };
        } & {
            id: string;
            ticketId: string;
            seatId: string;
        }) | null;
        ticketTier: {
            id: string;
            name: string;
            sectionId: string | null;
            price: import("@prisma/client/runtime/library").Decimal;
            availableQty: number;
            eventId: string;
        };
        booking: {
            event: {
                id: string;
                createdAt: Date;
                deletedAt: Date | null;
                description: string;
                slug: string;
                venueId: string;
                status: import("@prisma/client").$Enums.EventStatus;
                title: string;
                categoryId: string;
                organizerId: string;
                startTime: Date;
                endTime: Date;
                heroImageUrl: string;
                isFeatured: boolean;
            };
        } & {
            id: string;
            createdAt: Date;
            userId: string;
            status: import("@prisma/client").$Enums.BookingStatus;
            eventId: string;
            finalAmount: import("@prisma/client/runtime/library").Decimal;
            totalAmount: import("@prisma/client/runtime/library").Decimal;
            discountAmount: import("@prisma/client/runtime/library").Decimal;
            bookingRef: string;
        };
    } & {
        id: string;
        status: import("@prisma/client").$Enums.TicketStatus;
        bookingId: string;
        ticketTierId: string;
        qrCodeHash: string;
    }>;
}
