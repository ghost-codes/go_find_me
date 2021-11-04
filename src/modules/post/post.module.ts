import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { PassportModule } from '@nestjs/passport';
import { MulterModule } from '@nestjs/platform-express';
import { FilesModule } from 'src/global/gridfs/files.module';
import { FileService } from 'src/global/gridfs/files.service';
import { GridFsMulterConfigeService } from 'src/global/gridfs/gridfs.config';
import { PostController } from './post.controller';
import { PostService } from './post.service';
import { Post, PostSchema } from './schema/post.schema';

@Module({
  imports: [
    MulterModule.registerAsync({
      useClass: GridFsMulterConfigeService,
    }),
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
  ],
  controllers: [PostController],
  providers: [PostService, FileService],
})
export class PostModule {}
