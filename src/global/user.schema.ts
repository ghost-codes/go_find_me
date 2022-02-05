import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

export type UserDocument = User & Document;

@Schema()
export class User extends Document {
  @Prop({ required: true, unique: true })
  username: string;

  @Prop({ required: true, unique: true })
  email: string;

  @Prop({ unique: true, maxlength: 15, minlength: 11 })
  phone_number: string;

  @Prop({ default: null })
  confirmed_at: Date;

  @Prop({ required: true })
  password: string;

  @Prop({ required: true })
  passHash: string;

  @Prop({ default: [] })
  bookmarked_posts: string[];
}

export const UserSchema = SchemaFactory.createForClass(User);
