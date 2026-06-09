export declare enum EventStatus {
    DRAFT = "DRAFT",
    PUBLISHED = "PUBLISHED",
    CANCELLED = "CANCELLED",
    COMPLETED = "COMPLETED"
}
export declare class CreateTicketTierDto {
    name: string;
    price: number;
    availableQty: number;
}
export declare class CreateEventDto {
    title: string;
    description: string;
    categoryId: string;
    venueId: string;
    organizerId: string;
    startTime: string;
    endTime: string;
    heroImageUrl: string;
    status?: EventStatus;
    isFeatured?: boolean;
    ticketTiers?: CreateTicketTierDto[];
}
export declare class UpdateEventDto {
    title?: string;
    description?: string;
    categoryId?: string;
    venueId?: string;
    startTime?: string;
    endTime?: string;
    heroImageUrl?: string;
    status?: EventStatus;
    isFeatured?: boolean;
}
export declare class QueryEventDto {
    q?: string;
    city?: string;
    category?: string;
    featured?: string;
    skip?: string;
    take?: string;
}
export declare class CreateEventImageDto {
    imageUrl: string;
}
