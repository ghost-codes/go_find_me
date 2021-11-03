import { ApiProperty } from '@nestjs/swagger';

export class UserSession {
  @ApiProperty()
  accessToken: string;

  @ApiProperty()
  refreshToken: string;
}
