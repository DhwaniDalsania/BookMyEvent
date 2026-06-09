import { NotificationsService } from './notifications.service';
export declare class NotificationsController {
    private readonly notificationsService;
    constructor(notificationsService: NotificationsService);
    getUserNotifications(req: any): Promise<{
        message: string;
        id: string;
        createdAt: Date;
        userId: string;
        title: string;
        type: import("@prisma/client").$Enums.NotificationType;
        isRead: boolean;
    }[]>;
    markAllAsRead(req: any): Promise<import("@prisma/client").Prisma.BatchPayload>;
    markAsRead(id: string, req: any): Promise<{
        message: string;
        id: string;
        createdAt: Date;
        userId: string;
        title: string;
        type: import("@prisma/client").$Enums.NotificationType;
        isRead: boolean;
    }>;
}
