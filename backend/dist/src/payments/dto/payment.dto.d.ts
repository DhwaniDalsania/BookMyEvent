export declare class CreateOrderDto {
    bookingId: string;
}
export declare class VerifyPaymentDto {
    razorpayOrderId: string;
    razorpayPaymentId: string;
    razorpaySignature: string;
}
export declare class RefundPaymentDto {
    paymentId: string;
    amount?: number;
}
