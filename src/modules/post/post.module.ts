import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { PassportModule } from '@nestjs/passport';
import { User, UserSchema } from 'src/global/user.schema';
import { ImageUploadModule } from '../image-upload/image-upload.module';
import { ImageUploadService } from '../image-upload/image-upload.service';
import { PushNotificationModule } from '../push-notification/push-notification.module';
import { PostController } from './post.controller';
import { PostService } from './post.service';
import { Contribution, ContributionSchema } from './schema/contribution.schema';
import { Post, PostSchema } from './schema/post.schema';
import { UserService } from '../auth/user.service';
import { AuthModule } from '../auth/auth.module';
import * as bcrypt from 'bcrypt';
@Module({
  imports: [
    MongooseModule.forFeatureAsync([
      {
        name: Post.name,
        useFactory: () => {
          const schema = PostSchema;

          return schema;
        },
      },
    ]),
    MongooseModule.forFeatureAsync([
      {
        name: Contribution.name,
        useFactory: () => {
          const schema = ContributionSchema;

          return schema;
        },
      },
    ]),
    AuthModule,
    // MongooseModule.forFeatureAsync([
    //   {
    //     name: User.name,
    //     useFactory: () => {
    //       const schema = UserSchema;
    //       schema.pre<User>('save', function (next) {
    //         const user: User = this;
    //         bcrypt.hash(user.password, 10).then((value) => {
    //           user.password = value;
    //           next();
    //         });
    //       });

    //       return schema;
    //     },
    //   },
    // ]),

    PassportModule.register({ defaultStrategy: 'jwt' }),

    ImageUploadService,
    ImageUploadModule,
    PushNotificationModule,
  ],
  controllers: [PostController],
  providers: [PostService],
})
export class PostModule {}
