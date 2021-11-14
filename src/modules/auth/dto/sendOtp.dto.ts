import { ApiProperty } from '@nestjs/swagger';

export class SendOtpDTO {
  @ApiProperty()
  email: string;
}
