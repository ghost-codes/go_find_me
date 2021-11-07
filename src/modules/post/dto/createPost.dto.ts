import { ApiProperty } from '@nestjs/swagger';
import { LastSeen } from './updatePost.dto';

export class CreatePostDTO {
  @ApiProperty()
  imgs: string[];

  @ApiProperty()
  user_id: string;

  @ApiProperty()
  title: string;

  @ApiProperty()
  desc: string;

  @ApiProperty({ type: LastSeen })
  lastSeen: LastSeen;
}
// export class LastSeen {
//   @ApiProperty()
//   location: string;

//   @ApiProperty()
//   date: Date;
// }
