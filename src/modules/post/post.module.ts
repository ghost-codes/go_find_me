import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { PassportModule } from '@nestjs/passport';
import { ImageUploadModule } from '../image-upload/image-upload.module';
import { ImageUploadService } from '../image-upload/image-upload.service';
import { PushNotificationModule } from '../push-notification/push-notification.module';
import { PostController } from './post.controller';
import { PostService } from './post.service';
import { Contribution, ContributionSchema } from './schema/contribution.schema';
import { Post, PostSchema } from './schema/post.schema';

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

    PassportModule.register({ defaultStrategy: 'jwt' }),
    ImageUploadService,
    ImageUploadModule,
    PushNotificationModule,
  ],
  controllers: [PostController],
  providers: [PostService],
})
export class PostModule {}
