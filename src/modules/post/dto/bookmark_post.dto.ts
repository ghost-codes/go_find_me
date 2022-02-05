import { ApiProperty } from '@nestjs/swagger';
import { LastSeen } from './updatePost.dto';

export class BookmarkPostDTO {
  @ApiProperty()
  postId: string;
}
// export class LastSeen {
//   @ApiProperty()
//   location: string;

//   @ApiProperty()
//   date: Date;
// }
