import {
  IsArray,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsString,
  ValidateNested,
} from 'class-validator';
import { Type } from 'class-transformer';

export class TicketRequestDto {
  @IsString()
  @IsNotEmpty()
  ticketTierId: string;

  @IsString()
  @IsNotEmpty()
  seatId: string;
}

export class CreateBookingDto {
  @IsString()
  @IsNotEmpty()
  eventId: string;

  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => TicketRequestDto)
  tickets: TicketRequestDto[];

  @IsNumber()
  @IsOptional()
  discountAmount?: number;
}
