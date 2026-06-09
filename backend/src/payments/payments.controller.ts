import {
  Controller,
  Post,
  Body,
  Headers,
  UseGuards,
  Request,
  Get,
  Param,
} from '@nestjs/common';
import { PaymentsService } from './payments.service';
import {
  CreateOrderDto,
  VerifyPaymentDto,
  RefundPaymentDto,
} from './dto/payment.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard } from '../auth/roles.guard';
import { Roles } from '../auth/roles.decorator';
import type { AuthenticatedRequest } from '../auth/authenticated-request.interface';

@Controller('payments')
export class PaymentsController {
  constructor(private readonly paymentsService: PaymentsService) {}

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('USER', 'ADMIN', 'ORGANIZER')
  @Post('create-order')
  createOrder(
    @Body() createOrderDto: CreateOrderDto,
    @Request() req: AuthenticatedRequest,
  ) {
    return this.paymentsService.createOrder(req.user.userId, createOrderDto);
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('USER', 'ADMIN', 'ORGANIZER')
  @Post('verify')
  verify(
    @Body() verifyPaymentDto: VerifyPaymentDto,
    @Request() req: AuthenticatedRequest,
  ) {
    return this.paymentsService.verifyPayment(
      req.user.userId,
      verifyPaymentDto,
    );
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('ADMIN')
  @Post('refund')
  refund(@Body() refundPaymentDto: RefundPaymentDto) {
    return this.paymentsService.refundPayment(refundPaymentDto);
  }

  // Webhook handler is Public but guarded by Razorpay's HMAC Signature validation inside the service
  @Post('webhook')
  webhook(
    @Headers('x-razorpay-signature') signature: string,
    @Body() payload: any,
  ) {
    return this.paymentsService.handleWebhook(signature, payload);
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('USER', 'ADMIN', 'ORGANIZER')
  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.paymentsService.findOne(id);
  }
}
