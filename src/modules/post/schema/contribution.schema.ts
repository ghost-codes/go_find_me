import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';

export type ContributionDocument = Contribution & Document;

@Schema()
export class Contribution {
  @Prop({ required: true })
  location_sighted: string;

  @Prop({ required: true })
  post_id: string;

  @Prop({ required: true })
  user_id: string;

  @Prop()
  time_sighted: Date;

  @Prop()
  date_sighted: Date;

  @Prop({ default: Date.now })
  created_at: Date;

  @Prop({ default: Date.now })
  updated_at: Date;
}

export const ContributionSchema = SchemaFactory.createForClass(Contribution);
