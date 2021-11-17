import { ApiProperty } from '@nestjs/swagger';

export class SignUpDTO {
  @ApiProperty()
  email: string;

  @ApiProperty()
  password: string;

  @ApiProperty()
  phone_number: string;

  @ApiProperty()
  username: string;
}
