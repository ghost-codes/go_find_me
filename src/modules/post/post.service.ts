import {
  Injectable,
  InternalServerErrorException,
  NotFoundException,
} from '@nestjs/common';
import { Post, PostDocument } from './schema/post.schema';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { CreatePost, UpdatePost } from './interfaces/createpost.interface';

import { InjectConnection } from '@nestjs/mongoose';
import { ImageUploadService } from '../image-upload/image-upload.service';
import { Connection } from 'mongoose';
import {
  Contribution,
  ContributionDocument,
} from './schema/contribution.schema';
import { CreateContribution } from './interfaces/create_contribution.interface';

@Injectable()
export class PostService {
  constructor(
    @InjectConnection() private readonly connection: Connection,

    @InjectModel(Post.name) private readonly postModel: Model<PostDocument>,
    private readonly imageUploadService: ImageUploadService,

    @InjectModel(Contribution.name)
    private readonly contributionModel: Model<ContributionDocument>,
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
    const post: Post = await this.postModel.findById(postId);
    const keys: string[] = [];
    post.imgs.forEach(async (imagePath: string) => {
      const pathSections: string[] = imagePath.split('/');
      console.log(pathSections);
      keys.push(pathSections.pop());
    });
    await this.imageUploadService.deleteFiles(keys);

    post.contributions.forEach(
      async (element) =>
        await this.contributionModel.findByIdAndDelete(element),
    );

    const deletedPost: Post = await this.postModel.findByIdAndDelete(postId);
    if (!deletedPost)
      throw new InternalServerErrorException('Error Could not delete post');

    return true;
  }

  async createContribution(
    createContribution: CreateContribution,
  ): Promise<Post> {
    const newContribution = new this.contributionModel(createContribution);

    const savedContribution = await newContribution.save();
    if (!savedContribution)
      throw new InternalServerErrorException('Sorry Error Occured');

    const post = await this.postModel.findById(savedContribution.post_id);
    post.contributions = [...post.contributions, savedContribution.id];
    const updatedPost = await this.postModel.findByIdAndUpdate(
      savedContribution.post_id,
      post,
    );

    if (!updatedPost)
      throw new InternalServerErrorException('Sorry Error Occured');
    return updatedPost;
  }
}
