import { PrismaService } from '../prisma/prisma.service';
import { CreateEventDto, UpdateEventDto, QueryEventDto, CreateEventImageDto } from './dto/event.dto';
export declare class EventsService {
    private prisma;
    constructor(prisma: PrismaService);
    private slugify;
    create(createEventDto: CreateEventDto): Promise<{
        category: {
            id: string;
            createdAt: Date;
            updatedAt: Date;
            name: string;
            slug: string;
            iconUrl: string | null;
        };
        venue: {
            id: string;
            createdAt: Date;
            name: string;
            address: string;
            city: string;
            state: string;
            zipCode: string;
            latitude: import("@prisma/client/runtime/library").Decimal | null;
            longitude: import("@prisma/client/runtime/library").Decimal | null;
            googleMapsUrl: string | null;
            placeId: string | null;
        };
        ticketTiers: {
            id: string;
            name: string;
            sectionId: string | null;
            price: import("@prisma/client/runtime/library").Decimal;
            availableQty: number;
            eventId: string;
        }[];
    } & {
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
    }>;
    findAll(query: QueryEventDto): import("@prisma/client").Prisma.PrismaPromise<({
        organizer: {
            id: string;
            createdAt: Date;
            updatedAt: Date;
            deletedAt: Date | null;
            name: string;
            userId: string;
            description: string | null;
            logoUrl: string | null;
            contactEmail: string;
            contactPhone: string | null;
            isVerified: boolean;
            verificationStatus: import("@prisma/client").$Enums.VerificationStatus;
            verificationDate: Date | null;
        };
        metrics: {
            updatedAt: Date;
            totalViews: bigint;
            totalBookings: number;
            totalTicketsSold: number;
            wishlistCount: number;
            reviewCount: number;
            averageRating: import("@prisma/client/runtime/library").Decimal;
            revenueGenerated: import("@prisma/client/runtime/library").Decimal;
            eventId: string;
        } | null;
        category: {
            id: string;
            createdAt: Date;
            updatedAt: Date;
            name: string;
            slug: string;
            iconUrl: string | null;
        };
        venue: {
            id: string;
            createdAt: Date;
            name: string;
            address: string;
            city: string;
            state: string;
            zipCode: string;
            latitude: import("@prisma/client/runtime/library").Decimal | null;
            longitude: import("@prisma/client/runtime/library").Decimal | null;
            googleMapsUrl: string | null;
            placeId: string | null;
        };
        ticketTiers: {
            id: string;
            name: string;
            sectionId: string | null;
            price: import("@prisma/client/runtime/library").Decimal;
            availableQty: number;
            eventId: string;
        }[];
    } & {
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
    })[]>;
    findOne(id: string): Promise<{
        organizer: {
            id: string;
            createdAt: Date;
            updatedAt: Date;
            deletedAt: Date | null;
            name: string;
            userId: string;
            description: string | null;
            logoUrl: string | null;
            contactEmail: string;
            contactPhone: string | null;
            isVerified: boolean;
            verificationStatus: import("@prisma/client").$Enums.VerificationStatus;
            verificationDate: Date | null;
        };
        metrics: {
            updatedAt: Date;
            totalViews: bigint;
            totalBookings: number;
            totalTicketsSold: number;
            wishlistCount: number;
            reviewCount: number;
            averageRating: import("@prisma/client/runtime/library").Decimal;
            revenueGenerated: import("@prisma/client/runtime/library").Decimal;
            eventId: string;
        } | null;
        category: {
            id: string;
            createdAt: Date;
            updatedAt: Date;
            name: string;
            slug: string;
            iconUrl: string | null;
        };
        venue: {
            id: string;
            createdAt: Date;
            name: string;
            address: string;
            city: string;
            state: string;
            zipCode: string;
            latitude: import("@prisma/client/runtime/library").Decimal | null;
            longitude: import("@prisma/client/runtime/library").Decimal | null;
            googleMapsUrl: string | null;
            placeId: string | null;
        };
        ticketTiers: {
            id: string;
            name: string;
            sectionId: string | null;
            price: import("@prisma/client/runtime/library").Decimal;
            availableQty: number;
            eventId: string;
        }[];
        images: {
            id: string;
            createdAt: Date;
            eventId: string;
            imageUrl: string;
            sortOrder: number;
        }[];
    } & {
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
    }>;
    findOneBySlug(slug: string): Promise<{
        organizer: {
            id: string;
            createdAt: Date;
            updatedAt: Date;
            deletedAt: Date | null;
            name: string;
            userId: string;
            description: string | null;
            logoUrl: string | null;
            contactEmail: string;
            contactPhone: string | null;
            isVerified: boolean;
            verificationStatus: import("@prisma/client").$Enums.VerificationStatus;
            verificationDate: Date | null;
        };
        metrics: {
            updatedAt: Date;
            totalViews: bigint;
            totalBookings: number;
            totalTicketsSold: number;
            wishlistCount: number;
            reviewCount: number;
            averageRating: import("@prisma/client/runtime/library").Decimal;
            revenueGenerated: import("@prisma/client/runtime/library").Decimal;
            eventId: string;
        } | null;
        category: {
            id: string;
            createdAt: Date;
            updatedAt: Date;
            name: string;
            slug: string;
            iconUrl: string | null;
        };
        venue: {
            id: string;
            createdAt: Date;
            name: string;
            address: string;
            city: string;
            state: string;
            zipCode: string;
            latitude: import("@prisma/client/runtime/library").Decimal | null;
            longitude: import("@prisma/client/runtime/library").Decimal | null;
            googleMapsUrl: string | null;
            placeId: string | null;
        };
        ticketTiers: {
            id: string;
            name: string;
            sectionId: string | null;
            price: import("@prisma/client/runtime/library").Decimal;
            availableQty: number;
            eventId: string;
        }[];
        images: {
            id: string;
            createdAt: Date;
            eventId: string;
            imageUrl: string;
            sortOrder: number;
        }[];
    } & {
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
    }>;
    private ensureVenueSeating;
    getSeatMap(eventId: string): Promise<{
        eventId: string;
        venueName: string;
        rows: number;
        cols: number;
        ticketTiers: {
            id: string;
            name: string;
            price: number;
            availableQty: number;
        }[];
        seats: {
            id: string;
            rowName: string;
            seatNumber: string;
            label: string;
            sectionName: string;
            ticketTierId: string | null;
            ticketTierName: string | null;
            price: number;
            status: string;
        }[];
    }>;
    update(id: string, updateEventDto: UpdateEventDto): Promise<{
        organizer: {
            id: string;
            createdAt: Date;
            updatedAt: Date;
            deletedAt: Date | null;
            name: string;
            userId: string;
            description: string | null;
            logoUrl: string | null;
            contactEmail: string;
            contactPhone: string | null;
            isVerified: boolean;
            verificationStatus: import("@prisma/client").$Enums.VerificationStatus;
            verificationDate: Date | null;
        };
        metrics: {
            updatedAt: Date;
            totalViews: bigint;
            totalBookings: number;
            totalTicketsSold: number;
            wishlistCount: number;
            reviewCount: number;
            averageRating: import("@prisma/client/runtime/library").Decimal;
            revenueGenerated: import("@prisma/client/runtime/library").Decimal;
            eventId: string;
        } | null;
        category: {
            id: string;
            createdAt: Date;
            updatedAt: Date;
            name: string;
            slug: string;
            iconUrl: string | null;
        };
        venue: {
            id: string;
            createdAt: Date;
            name: string;
            address: string;
            city: string;
            state: string;
            zipCode: string;
            latitude: import("@prisma/client/runtime/library").Decimal | null;
            longitude: import("@prisma/client/runtime/library").Decimal | null;
            googleMapsUrl: string | null;
            placeId: string | null;
        };
        ticketTiers: {
            id: string;
            name: string;
            sectionId: string | null;
            price: import("@prisma/client/runtime/library").Decimal;
            availableQty: number;
            eventId: string;
        }[];
        images: {
            id: string;
            createdAt: Date;
            eventId: string;
            imageUrl: string;
            sortOrder: number;
        }[];
    } & {
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
    }>;
    remove(id: string): Promise<{
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
    }>;
    addImage(eventId: string, dto: CreateEventImageDto): Promise<{
        id: string;
        createdAt: Date;
        eventId: string;
        imageUrl: string;
        sortOrder: number;
    }>;
    removeImage(imageId: string): Promise<{
        id: string;
        createdAt: Date;
        eventId: string;
        imageUrl: string;
        sortOrder: number;
    }>;
}
