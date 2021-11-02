import { ApiProperty } from '@nestjs/swagger';

export class LoginEmailDTO {
  @ApiProperty()
  identity: string;

  @ApiProperty()
  password: string;
}
