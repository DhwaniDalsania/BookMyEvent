import { ReviewsService } from './reviews.service';
import { CreateReviewDto, UpdateReviewDto } from './dto/review.dto';
import type { AuthenticatedRequest } from '../auth/authenticated-request.interface';
export declare class ReviewsController {
    private readonly reviewsService;
    constructor(reviewsService: ReviewsService);
    create(createReviewDto: CreateReviewDto, req: AuthenticatedRequest): Promise<{
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
            id: string;
            firstName: string;
            lastName: string;
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
    update(id: string, updateReviewDto: UpdateReviewDto, req: AuthenticatedRequest): Promise<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        userId: string;
        eventId: string;
        rating: number;
        comment: string | null;
    }>;
    remove(id: string, req: AuthenticatedRequest): Promise<{
        id: string;
        createdAt: Date;
        updatedAt: Date;
        userId: string;
        eventId: string;
        rating: number;
        comment: string | null;
    }>;
}
