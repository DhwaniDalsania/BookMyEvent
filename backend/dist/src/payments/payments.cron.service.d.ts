import { PrismaService } from '../prisma/prisma.service';
import { BookingsService } from '../bookings/bookings.service';
export declare class PaymentsCronService {
    private prisma;
    private bookingsService;
    private readonly logger;
    private razorpay;
    constructor(prisma: PrismaService, bookingsService: BookingsService);
    handlePendingBookings(): Promise<void>;
    private cancelBooking;
}
