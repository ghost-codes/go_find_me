import { ApiProperty } from '@nestjs/swagger';

export class ChangeForgottenPasswordDto {
  @ApiProperty()
  newPassword: string;

  @ApiProperty()
  hash: string;

  @ApiProperty()
  email: string;
}
