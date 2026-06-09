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
        finalAmount: import("@prisma/client/runtime/library").Decimal;
        totalAmount: import("@prisma/client/runtime/library").Decimal;
        discountAmount: import("@prisma/client/runtime/library").Decimal;
        eventId: string;
        bookingRef: string;
    }>;
    findMyBookings(req: any): Promise<({
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
    cancel(id: string, req: any): Promise<{
        message: string;
    }>;
    simulatePaymentSuccess(id: string): Promise<{
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
}
