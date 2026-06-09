import { PrismaService } from '../prisma/prisma.service';
import { CreateReviewDto, UpdateReviewDto } from './dto/review.dto';
export declare class ReviewsService {
    private prisma;
    constructor(prisma: PrismaService);
    create(userId: string, dto: CreateReviewDto): Promise<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        userId: string;
        eventId: string;
        rating: number;
        comment: string | null;
    }>;
    update(userId: string, id: string, dto: UpdateReviewDto): Promise<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        userId: string;
        eventId: string;
        rating: number;
        comment: string | null;
    }>;
    remove(userId: string, id: string, userRole: string): Promise<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        userId: string;
        eventId: string;
        rating: number;
        comment: string | null;
    }>;
    getEventReviews(eventId: string): Promise<({
        user: {
            firstName: string;
            lastName: string;
            id: string;
        };
    } & {
        id: string;
        createdAt: Date;
        updatedAt: Date;
        userId: string;
        eventId: string;
        rating: number;
        comment: string | null;
    })[]>;
}
