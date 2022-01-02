import { ApiProperty } from '@nestjs/swagger';

export class ChangeForgottenPasswordDto {
  @ApiProperty()
  newPassword: string;

  @ApiProperty()
  token: string;
}
