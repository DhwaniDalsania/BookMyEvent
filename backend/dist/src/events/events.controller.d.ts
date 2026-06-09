import { EventsService } from './events.service';
import { CreateEventDto, UpdateEventDto, QueryEventDto, CreateEventImageDto } from './dto/event.dto';
export declare class EventsController {
    private readonly eventsService;
    constructor(eventsService: EventsService);
    create(createEventDto: CreateEventDto): Promise<{
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
    } & {
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
    })[]>;
    search(query: QueryEventDto): import("@prisma/client").Prisma.PrismaPromise<({
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
    } & {
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
    })[]>;
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
        images: {
            id: string;
            createdAt: Date;
            imageUrl: string;
            sortOrder: number;
            eventId: string;
        }[];
    } & {
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
    }>;
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
        images: {
            id: string;
            createdAt: Date;
            imageUrl: string;
            sortOrder: number;
            eventId: string;
        }[];
    } & {
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
    }>;
    update(id: string, updateEventDto: UpdateEventDto): Promise<{
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
    }>;
    remove(id: string): Promise<{
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
    }>;
    addImage(id: string, dto: CreateEventImageDto): Promise<{
        id: string;
        createdAt: Date;
        imageUrl: string;
        sortOrder: number;
        eventId: string;
    }>;
    removeImage(imageId: string): Promise<{
        id: string;
        createdAt: Date;
        imageUrl: string;
        sortOrder: number;
        eventId: string;
    }>;
}
