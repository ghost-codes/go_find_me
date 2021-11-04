import {
  Injectable,
  InternalServerErrorException,
  NotFoundException,
} from '@nestjs/common';
import { Post, PostDocument } from './schema/post.schema';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { CreatePost, UpdatePost } from './createpost.interface';

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

  async updatePost(updatePostModel: UpdatePost): Promise<Post> {
    const updatedPost = this.postModel.findByIdAndUpdate(
      updatePostModel.id,
      updatePostModel,
    );
    if (!updatedPost) throw new NotFoundException('Post not found');
    return updatedPost;
  }

  async deletePost(postId: string): Promise<string> {
    const deletedpost = this.postModel.findByIdAndDelete(postId);
    if (!deletedpost) throw new NotFoundException('Post does not exist');
    return 'The post has been deleted';
  }
}
