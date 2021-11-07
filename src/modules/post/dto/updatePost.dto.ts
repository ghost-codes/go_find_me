import { ApiProperty } from '@nestjs/swagger';

export class LastSeen {
  @ApiProperty()
  location: string;

  @ApiProperty()
  date: Date;
}
export class UpdatePostDTO {
  @ApiProperty()
  id: string;

  @ApiProperty()
  imgs: string[];

  @ApiProperty()
  user_id: string;

  @ApiProperty()
  title: string;

  @ApiProperty()
  desc: string;

  @ApiProperty()
  status: string;

  @ApiProperty({ type: LastSeen })
  lastSeen: LastSeen;
}
