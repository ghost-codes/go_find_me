import { Injectable, InternalServerErrorException } from '@nestjs/common';
import { Post, PostDocument } from './schema/post.schema';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { CreatePost } from './createpost.interface';

@Injectable()
export class PostService {
  constructor(
    @InjectModel(Post.name) private readonly postModel: Model<PostDocument>,
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
}
