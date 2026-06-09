"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AppModule = void 0;
const common_1 = require("@nestjs/common");
const schedule_1 = require("@nestjs/schedule");
const config_1 = require("@nestjs/config");
const app_controller_1 = require("./app.controller");
const app_service_1 = require("./app.service");
const auth_module_1 = require("./auth/auth.module");
const prisma_module_1 = require("./prisma/prisma.module");
const categories_module_1 = require("./categories/categories.module");
const venues_module_1 = require("./venues/venues.module");
const organizers_module_1 = require("./organizers/organizers.module");
const events_module_1 = require("./events/events.module");
const seat_holds_module_1 = require("./seat-holds/seat-holds.module");
const tickets_module_1 = require("./tickets/tickets.module");
const bookings_module_1 = require("./bookings/bookings.module");
const payments_module_1 = require("./payments/payments.module");
const wishlist_module_1 = require("./wishlist/wishlist.module");
const reviews_module_1 = require("./reviews/reviews.module");
const notifications_module_1 = require("./notifications/notifications.module");
const analytics_module_1 = require("./analytics/analytics.module");
const uploads_module_1 = require("./uploads/uploads.module");
let AppModule = class AppModule {
};
exports.AppModule = AppModule;
exports.AppModule = AppModule = __decorate([
    (0, common_1.Module)({
        imports: [
            config_1.ConfigModule.forRoot({ isGlobal: true }),
            schedule_1.ScheduleModule.forRoot(),
            auth_module_1.AuthModule,
            prisma_module_1.PrismaModule,
            categories_module_1.CategoriesModule,
            venues_module_1.VenuesModule,
            organizers_module_1.OrganizersModule,
            events_module_1.EventsModule,
            seat_holds_module_1.SeatHoldsModule,
            tickets_module_1.TicketsModule,
            bookings_module_1.BookingsModule,
            payments_module_1.PaymentsModule,
            wishlist_module_1.WishlistModule,
            reviews_module_1.ReviewsModule,
            notifications_module_1.NotificationsModule,
            analytics_module_1.AnalyticsModule,
            uploads_module_1.UploadsModule,
        ],
        controllers: [app_controller_1.AppController],
        providers: [app_service_1.AppService],
    })
], AppModule);
//# sourceMappingURL=app.module.js.map