import { PrismaService } from '../prisma/prisma.service';
import { BookingsService } from '../bookings/bookings.service';
import { NotificationsService } from '../notifications/notifications.service';
import { CreateOrderDto, VerifyPaymentDto, RefundPaymentDto } from './dto/payment.dto';
export declare class PaymentsService {
    private prisma;
    private bookingsService;
    private notificationsService;
    private razorpay;
    constructor(prisma: PrismaService, bookingsService: BookingsService, notificationsService: NotificationsService);
    createOrder(userId: string, dto: CreateOrderDto): Promise<{
        paymentId: string;
        razorpayOrderId: string;
        amount: string | number;
        currency: string;
    }>;
    verifyPayment(userId: string, dto: VerifyPaymentDto): Promise<{
        success: boolean;
        message: string;
    }>;
    refundPayment(dto: RefundPaymentDto): Promise<{
        success: boolean;
        refundId: any;
    }>;
    handleWebhook(signature: string, payload: any): Promise<{
        success: boolean;
    }>;
    findOne(id: string): Promise<{
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
    } | null>;
}
