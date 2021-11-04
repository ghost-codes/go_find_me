import {
  Controller,
  Get,
  UploadedFiles,
  UseGuards,
  UseInterceptors,
  Post,
  Body,
} from '@nestjs/common';

import { FilesInterceptor } from '@nestjs/platform-express';
import { ApiConsumes } from '@nestjs/swagger';
import { FileService } from 'src/global/gridfs/files.service';
import { JwtAuthGuard } from '../auth/guard/jwt.guard';
// import { CreatePost } from './createpost.interface';
import { CreatePostDTO } from './dto/createPost.dto';
import { PostService } from './post.service';
// import { Post } from './schema/post.schema';

@Controller('post')
export class PostController {
  constructor(
    private postService: PostService,
    private fileService: FileService,
  ) {}

  @Get()
  getAllPosts(): Promise<any> {
    return this.postService.getPosts();
  }

  @UseGuards(JwtAuthGuard)
  @Post()
  @ApiConsumes('multipart/formdata')
  @UseInterceptors(FilesInterceptor('uploads'))
  createPost(@UploadedFiles() files, @Body() body: CreatePostDTO) {
    const imgPaths = [];
    files.forEach((file) => {
      const fileReponse = `/post/${file.filename}`;
      imgPaths.push(fileReponse);
    });

    body.imgs = imgPaths;

    return this.postService.createPost(body);
  }
}
