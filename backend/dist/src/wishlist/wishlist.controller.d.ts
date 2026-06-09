import { WishlistService } from './wishlist.service';
import type { AuthenticatedRequest } from '../auth/authenticated-request.interface';
export declare class WishlistController {
    private readonly wishlistService;
    constructor(wishlistService: WishlistService);
    checkStatus(eventId: string, req: AuthenticatedRequest): Promise<{
        id: string;
        createdAt: Date;
        userId: string;
        eventId: string;
    }>;
    remove(eventId: string, req: AuthenticatedRequest): Promise<{
        id: string;
        createdAt: Date;
        userId: string;
        eventId: string;
    }>;
    getUserWishlist(req: AuthenticatedRequest): Promise<({
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
        };
    } & {
        id: string;
        createdAt: Date;
        userId: string;
        eventId: string;
    })[]>;
}
