import { PrismaService } from '../prisma/prisma.service';
export declare class AnalyticsService {
    private prisma;
    constructor(prisma: PrismaService);
    getDashboardMetrics(): Promise<{
        totalUsers: number;
        activeOrganizers: number;
        totalEvents: number;
        totalBookings: number;
        totalRevenue: number | import("@prisma/client/runtime/library").Decimal;
        ticketSales: number;
    }>;
    getTopEvents(): Promise<({
        _count: {
            bookings: number;
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
    getRevenueData(): Promise<{
        createdAt: Date;
        amount: import("@prisma/client/runtime/library").Decimal;
    }[]>;
    getBookingsData(): Promise<{
        createdAt: Date;
        status: import("@prisma/client").$Enums.BookingStatus;
        finalAmount: import("@prisma/client/runtime/library").Decimal;
    }[]>;
}
