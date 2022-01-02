import { ApiProperty } from '@nestjs/swagger';

export class SendCodeForgottenPassword {
  @ApiProperty()
  email: string;
}
