import { ApiProperty } from '@nestjs/swagger';

export class ConfirmDTO {
  @ApiProperty()
  confirmation_token: string;

  @ApiProperty()
  otp: string;
}
