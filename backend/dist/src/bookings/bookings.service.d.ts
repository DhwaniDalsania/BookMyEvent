import { PrismaService } from '../prisma/prisma.service';
import { TicketsService } from '../tickets/tickets.service';
import { CreateBookingDto } from './dto/booking.dto';
export declare class BookingsService {
    private prisma;
    private ticketsService;
    constructor(prisma: PrismaService, ticketsService: TicketsService);
    private generateBookingRef;
    create(userId: string, dto: CreateBookingDto): Promise<{
        id: string;
        createdAt: Date;
        userId: string;
        status: import("@prisma/client").$Enums.BookingStatus;
        finalAmount: import("@prisma/client/runtime/library").Decimal;
        totalAmount: import("@prisma/client/runtime/library").Decimal;
        discountAmount: import("@prisma/client/runtime/library").Decimal;
        eventId: string;
        bookingRef: string;
    }>;
    confirmBookingAndGenerateTickets(bookingId: string): Promise<{
        id: string;
        createdAt: Date;
        userId: string;
        status: import("@prisma/client").$Enums.BookingStatus;
        finalAmount: import("@prisma/client/runtime/library").Decimal;
        totalAmount: import("@prisma/client/runtime/library").Decimal;
        discountAmount: import("@prisma/client/runtime/library").Decimal;
        eventId: string;
        bookingRef: string;
    }>;
    cancel(userId: string, bookingId: string): Promise<{
        message: string;
    }>;
    findOne(id: string): Promise<({
        tickets: ({
            ticketSeat: {
                id: string;
                ticketId: string;
                seatId: string;
            } | null;
        } & {
            id: string;
            status: import("@prisma/client").$Enums.TicketStatus;
            bookingId: string;
            ticketTierId: string;
            qrCodeHash: string;
        })[];
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
        payment: {
            id: string;
            createdAt: Date;
            updatedAt: Date;
            userId: string;
            status: import("@prisma/client").$Enums.PaymentStatus;
            bookingId: string;
            amount: import("@prisma/client/runtime/library").Decimal;
            currency: string;
            provider: string;
            razorpayOrderId: string | null;
            razorpayPaymentId: string | null;
            razorpaySignature: string | null;
            paymentMethod: string | null;
            refundedAmount: import("@prisma/client/runtime/library").Decimal;
        } | null;
    } & {
        id: string;
        createdAt: Date;
        userId: string;
        status: import("@prisma/client").$Enums.BookingStatus;
        finalAmount: import("@prisma/client/runtime/library").Decimal;
        totalAmount: import("@prisma/client/runtime/library").Decimal;
        discountAmount: import("@prisma/client/runtime/library").Decimal;
        eventId: string;
        bookingRef: string;
    }) | null>;
    findMyBookings(userId: string): Promise<({
        tickets: {
            id: string;
            status: import("@prisma/client").$Enums.TicketStatus;
            bookingId: string;
            ticketTierId: string;
            qrCodeHash: string;
        }[];
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
        payment: {
            id: string;
            createdAt: Date;
            updatedAt: Date;
            userId: string;
            status: import("@prisma/client").$Enums.PaymentStatus;
            bookingId: string;
            amount: import("@prisma/client/runtime/library").Decimal;
            currency: string;
            provider: string;
            razorpayOrderId: string | null;
            razorpayPaymentId: string | null;
            razorpaySignature: string | null;
            paymentMethod: string | null;
            refundedAmount: import("@prisma/client/runtime/library").Decimal;
        } | null;
    } & {
        id: string;
        createdAt: Date;
        userId: string;
        status: import("@prisma/client").$Enums.BookingStatus;
        finalAmount: import("@prisma/client/runtime/library").Decimal;
        totalAmount: import("@prisma/client/runtime/library").Decimal;
        discountAmount: import("@prisma/client/runtime/library").Decimal;
        eventId: string;
        bookingRef: string;
    })[]>;
}
