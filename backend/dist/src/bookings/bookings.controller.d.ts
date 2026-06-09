import { BookingsService } from './bookings.service';
import { CreateBookingDto } from './dto/booking.dto';
export declare class BookingsController {
    private readonly bookingsService;
    constructor(bookingsService: BookingsService);
    create(createBookingDto: CreateBookingDto, req: any): Promise<{
        id: string;
        createdAt: Date;
        userId: string;
        status: import("@prisma/client").$Enums.BookingStatus;
        eventId: string;
        bookingRef: string;
        totalAmount: import("@prisma/client/runtime/library").Decimal;
        discountAmount: import("@prisma/client/runtime/library").Decimal;
        finalAmount: import("@prisma/client/runtime/library").Decimal;
    }>;
    findMyBookings(req: any): Promise<({
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
        tickets: {
            id: string;
            status: import("@prisma/client").$Enums.TicketStatus;
            bookingId: string;
            ticketTierId: string;
            qrCodeHash: string;
        }[];
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
    })[]>;
    findOne(id: string): Promise<({
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
        tickets: ({
            ticketSeat: {
                id: string;
                seatId: string;
                ticketId: string;
            } | null;
        } & {
            id: string;
            status: import("@prisma/client").$Enums.TicketStatus;
            bookingId: string;
            ticketTierId: string;
            qrCodeHash: string;
        })[];
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
    }) | null>;
    cancel(id: string, req: any): Promise<{
        message: string;
    }>;
    simulatePaymentSuccess(id: string): Promise<{
        id: string;
        createdAt: Date;
        userId: string;
        status: import("@prisma/client").$Enums.BookingStatus;
        eventId: string;
        bookingRef: string;
        totalAmount: import("@prisma/client/runtime/library").Decimal;
        discountAmount: import("@prisma/client/runtime/library").Decimal;
        finalAmount: import("@prisma/client/runtime/library").Decimal;
    }>;
}
