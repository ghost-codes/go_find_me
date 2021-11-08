import { Prop, Schema, raw, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

export type PostDocument = Post & Document;

@Schema()
export class Post extends Document {
  @Prop({ required: true })
  user_id: string;

  @Prop()
  imgs: string[];

  @Prop()
  title: string;

  @Prop()
  desc: string;

  @Prop()
  contributions: string[];

  @Prop()
  privilleged: string[];

  @Prop({ default: 0 })
  shares: number;

  @Prop(
    raw({
      location: { type: String },
      date: { type: Date },
    }),
  )
  last_seen: Record<string, any>;

  @Prop({ default: 'Not Found' })
  status: string;

  @Prop({ default: Date.now })
  created_at: Date;

  @Prop({ default: Date.now })
  updated_at: Date;
}

export const PostSchema = SchemaFactory.createForClass(Post);
