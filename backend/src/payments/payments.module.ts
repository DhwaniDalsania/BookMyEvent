import { Module } from '@nestjs/common';
import { PaymentsService } from './payments.service';
import { PaymentsCronService } from './payments.cron.service';
import { PaymentsController } from './payments.controller';
import { BookingsModule } from '../bookings/bookings.module';
import { NotificationsModule } from '../notifications/notifications.module';

@Module({
  imports: [BookingsModule, NotificationsModule],
  controllers: [PaymentsController],
  providers: [PaymentsService, PaymentsCronService],
  exports: [PaymentsService],
})
export class PaymentsModule {}
