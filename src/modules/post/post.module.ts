import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { PassportModule } from '@nestjs/passport';
import { ImageUploadModule } from '../image-upload/image-upload.module';
import { ImageUploadService } from '../image-upload/image-upload.service';
import { PostController } from './post.controller';
import { PostService } from './post.service';
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
    PassportModule.register({ defaultStrategy: 'jwt' }),
    ImageUploadService,
    ImageUploadModule,
  ],
  controllers: [PostController],
  providers: [PostService],
})
export class PostModule {}
