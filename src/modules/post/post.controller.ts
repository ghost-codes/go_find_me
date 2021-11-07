import {
  Controller,
  Get,
  UploadedFiles,
  UseGuards,
  Post,
  Body,
  Put,
  Delete,
  Param,
} from '@nestjs/common';
import { JwtAuthGuard } from '../auth/guard/jwt.guard';
// import { CreatePost } from './createpost.interface';
import { CreatePostDTO } from './dto/createPost.dto';
import { UpdatePostDTO } from './dto/updatePost.dto';
import { PostService } from './post.service';
// import { Post } from './schema/post.schema';

@Controller('api/post')
export class PostController {
  constructor(private postService: PostService) {}

  @Get()
  getAllPosts(): Promise<any> {
    return this.postService.getPosts();
  }

  // @UseGuards(JwtAuthGuard)
  @Post()
  createPost(@UploadedFiles() files, @Body() body: CreatePostDTO) {
    return this.postService.createPost(body);
  }

  @UseGuards(JwtAuthGuard)
  @Put(':postId')
  updatePost(@Body() body: UpdatePostDTO) {
    return this.postService.updatePost(body);
  }

  // @UseGuards(JwtAuthGuard)
  @Delete('delete_post/:postId')
  deletePost(@Param('postId') postId: string) {
    return this.postService.deletePost(postId);
  }
}
