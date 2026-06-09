import { PrismaService } from '../prisma/prisma.service';
export declare class WishlistService {
    private prisma;
    constructor(prisma: PrismaService);
    addEvent(userId: string, eventId: string): Promise<{
        id: string;
        createdAt: Date;
        userId: string;
        eventId: string;
    }>;
    removeEvent(userId: string, eventId: string): Promise<{
        id: string;
        createdAt: Date;
        userId: string;
        eventId: string;
    }>;
    getUserWishlist(userId: string): Promise<({
        event: {
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
    } & {
        id: string;
        createdAt: Date;
        userId: string;
        eventId: string;
    })[]>;
}
