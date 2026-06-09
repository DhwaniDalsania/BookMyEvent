export declare class TicketRequestDto {
    ticketTierId: string;
    seatId: string;
}
export declare class CreateBookingDto {
    eventId: string;
    tickets: TicketRequestDto[];
    discountAmount?: number;
}
