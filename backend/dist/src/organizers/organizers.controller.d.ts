import { OrganizersService } from './organizers.service';
import { CreateOrganizerDto, UpdateOrganizerDto } from './dto/organizer.dto';
import type { AuthenticatedRequest } from '../auth/authenticated-request.interface';
export declare class OrganizersController {
    private readonly organizersService;
    constructor(organizersService: OrganizersService);
    create(createOrganizerDto: CreateOrganizerDto, req: AuthenticatedRequest): Promise<{
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
    }>;
    findAll(): import("@prisma/client").Prisma.PrismaPromise<{
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
    }[]>;
    getMyProfile(req: AuthenticatedRequest): Promise<{
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
    }>;
    getMyEvents(req: AuthenticatedRequest): Promise<({
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
    getMyStats(req: AuthenticatedRequest): Promise<{
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
        eventCount: number;
        bookingCount: number;
        totalRevenue: number;
        events: ({
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
        })[];
    }>;
    findOne(id: string): Promise<{
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
    }>;
    getEvents(id: string): Promise<({
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
    update(id: string, updateOrganizerDto: UpdateOrganizerDto): Promise<{
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
    }>;
    remove(id: string): Promise<{
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
    }>;
}
