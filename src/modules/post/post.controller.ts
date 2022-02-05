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
  Query,
} from '@nestjs/common';
import { JwtAuthGuard } from '../auth/guard/jwt.guard';
import { CreatePostDTO } from './dto/createPost.dto';
import { CreateContributionDTO } from './dto/create_contribution.dto';
import { UpdatePostDTO } from './dto/updatePost.dto';
import { PostService } from './post.service';

@Controller('api/post')
export class PostController {
  constructor(private postService: PostService) {}

  @Get('?')
  getAllPosts(@Query('page') page: number): Promise<any> {
    return this.postService.getPosts(page);
  }

  @Get('/single_post/:id')
  getOnePost(@Param('id') id: string): Promise<any> {
    return this.postService.getOnePost(id);
  }

  @Get('/myposts/:id?')
  getMyPost(
    @Param('id') id: string,
    @Query('page') page: number,
  ): Promise<any> {
    return this.postService.getMyPosts(page, id);
  }

  @Get('/contributed_posts/:id')
  getCommentedPosts(@Param('id') id: string): Promise<any> {
    return this.postService.getCommentsPosts(id);
  }

  @Get('/bookmarked_posts/:id')
  getBookMarkedPosts(@Param('id') id: string): Promise<any> {
    return this.postService.getBookmarkedPosts(id);
  }
  // @Get('page?')
  // getPostsPerPage(@Query('page') page: number): Promise<any> {
  //   return this.postService.getPosts(page);
  // }

  @UseGuards(JwtAuthGuard)
  @Post()
  createPost(@UploadedFiles() files, @Body() body: CreatePostDTO) {
    return this.postService.createPost(body);
  }

  @UseGuards(JwtAuthGuard)
  @Put(':postId')
  updatePost(@Body() body: UpdatePostDTO, @Param('postId') postId: string) {
    console.log(body);
    return this.postService.updatePost(body);
  }

  @UseGuards(JwtAuthGuard)
  @Delete('delete_post/:postId')
  deletePost(@Param('postId') postId: string) {
    return this.postService.deletePost(postId);
  }

  @UseGuards(JwtAuthGuard)
  @Post('create_contribution')
  crateContribution(
    @Body() createContribution: CreateContributionDTO,
  ): Promise<any> {
    return this.postService.createContribution(createContribution);
  }
}
