import {
  Injectable,
  InternalServerErrorException,
  NotFoundException,
} from '@nestjs/common';
import { Post, PostDocument } from './schema/post.schema';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { CreatePost, UpdatePost } from './createpost.interface';

import { InjectConnection } from '@nestjs/mongoose';
import { ImageUploadService } from '../image-upload/image-upload.service';
import { Connection } from 'mongoose';

@Injectable()
export class PostService {
  constructor(
    @InjectConnection() private readonly connection: Connection,

    @InjectModel(Post.name) private readonly postModel: Model<PostDocument>,
    private readonly imageUploadService: ImageUploadService,
  ) {}

  async getPosts(): Promise<Post[]> {
    const post: Post[] = await this.postModel.find();
    if (!post) return [];
    return post;
  }

  async createPost(createPost: CreatePost): Promise<Post> {
    const newPost = new this.postModel(createPost);
    const savedPost: Post = await newPost.save();
    if (!savedPost)
      throw new InternalServerErrorException('Sorry Error Occured');

    return savedPost;
  }

  async updatePost(updatePostModel: UpdatePost): Promise<Post> {
    const updatedPost = this.postModel.findByIdAndUpdate(
      updatePostModel.id,
      updatePostModel,
    );
    if (!updatedPost) throw new NotFoundException('Post not found');
    return updatedPost;
  }

  async deletePost(postId: string): Promise<boolean> {
    const deletedpost: Post = await this.postModel.findById(postId);
    const keys: string[] = [];
    deletedpost.imgs.forEach(async (imagePath: string) => {
      const pathSections: string[] = imagePath.split('/');
      console.log(pathSections);
      keys.push(pathSections.pop());
    });
    await this.imageUploadService.deleteFile(keys);
    const deletPost: Post = await this.postModel.findByIdAndDelete(postId);
    if (!deletPost)
      throw new InternalServerErrorException('Error Could not delete post');

    return true;
  }
}
