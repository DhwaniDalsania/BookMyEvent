import {
  Controller,
  Get,
  Post,
  Delete,
  Param,
  UseGuards,
  Request,
} from '@nestjs/common';
import { WishlistService } from './wishlist.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard } from '../auth/roles.guard';
import { Roles } from '../auth/roles.decorator';
import type { AuthenticatedRequest } from '../auth/authenticated-request.interface';

@Controller('wishlist')
@UseGuards(JwtAuthGuard, RolesGuard)
export class WishlistController {
  constructor(private readonly wishlistService: WishlistService) {}

  @Roles('USER', 'ADMIN', 'ORGANIZER')
  @Post(':eventId')
  checkStatus(
    @Param('eventId') eventId: string,
    @Request() req: AuthenticatedRequest,
  ) {
    return this.wishlistService.addEvent(req.user.userId, eventId);
  }

  @Roles('USER', 'ADMIN', 'ORGANIZER')
  @Delete(':eventId')
  remove(
    @Param('eventId') eventId: string,
    @Request() req: AuthenticatedRequest,
  ) {
    return this.wishlistService.removeEvent(req.user.userId, eventId);
  }

  @Roles('USER', 'ADMIN', 'ORGANIZER')
  @Get('me')
  getUserWishlist(@Request() req: AuthenticatedRequest) {
    return this.wishlistService.getUserWishlist(req.user.userId);
  }
}
