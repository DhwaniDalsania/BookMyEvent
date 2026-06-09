import { PaymentsService } from './payments.service';
import { CreateOrderDto, VerifyPaymentDto, RefundPaymentDto } from './dto/payment.dto';
import type { AuthenticatedRequest } from '../auth/authenticated-request.interface';
export declare class PaymentsController {
    private readonly paymentsService;
    constructor(paymentsService: PaymentsService);
    createOrder(createOrderDto: CreateOrderDto, req: AuthenticatedRequest): Promise<{
        paymentId: string;
        razorpayOrderId: string;
        amount: string | number;
        currency: string;
    }>;
    verify(verifyPaymentDto: VerifyPaymentDto, req: AuthenticatedRequest): Promise<{
        success: boolean;
        message: string;
    }>;
    refund(refundPaymentDto: RefundPaymentDto): Promise<{
        success: boolean;
        refundId: any;
    }>;
    webhook(signature: string, payload: any): Promise<{
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
