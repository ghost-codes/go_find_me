import { ApiProperty } from '@nestjs/swagger';

export class CreateContributionDTO {
  @ApiProperty()
  location_sighted: string;

  @ApiProperty()
  post_id: string;

  @ApiProperty()
  time_sighted: Date;

  @ApiProperty()
  date_sighted: Date;
}
