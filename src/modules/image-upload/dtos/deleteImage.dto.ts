import { ApiProperty } from '@nestjs/swagger';

export class DeleteImageDTO {
  @ApiProperty()
  imgs: string[];
}
