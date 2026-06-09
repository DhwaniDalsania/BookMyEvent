import { IsNotEmpty, IsString } from 'class-validator';

export class CreateSeatHoldDto {
  @IsString()
  @IsNotEmpty()
  eventId: string;

  @IsString()
  @IsNotEmpty()
  seatId: string;
}
