import { ApiProperty } from '@nestjs/swagger';

export class SendPhoneOtpDTO {
  @ApiProperty()
  phone_number: string;
}
