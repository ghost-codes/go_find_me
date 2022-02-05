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
import { PushNotificationService } from '../push-notification/push-notification.service';
import { UserService } from '../auth/user.service';
import { User } from 'src/global/user.schema';

@Injectable()
export class PostService {
  constructor(
    @InjectConnection() private readonly connection: Connection,

    @InjectModel(Post.name) private readonly postModel: Model<PostDocument>,

    @InjectModel(Contribution.name)
    private readonly contributionModel: Model<ContributionDocument>,
    private readonly userService: UserService,

    private readonly imageUploadService: ImageUploadService,

    private readonly pushNotificationService: PushNotificationService,
  ) {}

  async getPosts(page: number): Promise<any> {
    if (!page) page = 0;
    const posts: Post[] = await this.postModel
      .find()
      .sort({ _id: -1 })
      .skip(page * 20)
      .limit(20);

    if (!posts)
      return { posts: [], next: null, prev: `/api/post/page=${page}` };
    if (posts.length < 20)
      return { posts, next: null, prev: `/api/post/page=${page}` };

    let next: number = page;
    return {
      posts,
      next: `/api/post/?page=${++next}`,
      prev: `/api/post/?page=${page}`,
    };
  }

  async getOnePost(id: string): Promise<any> {
    if (!id) throw new InternalServerErrorException('Sorry Error Occured');
    const post: Post = await this.postModel.findById(id);

    if (!post) throw new NotFoundException('Post not found');
    return { message: 'Success', post: post };
  }

  async getCommentsPosts(page: number, id: string): Promise<any> {
    if (!page) page = 0;
    if (!id) throw new InternalServerErrorException('Sorry Error Occured');
    const posts: Post[] = await this.postModel
      .find({ contributions: id })
      .sort({ _id: -1 })
      .skip(page * 20)
      .limit(20);

    if (!posts)
      return {
        posts: [],
        next: null,
        prev: `/api/post/contributed_posts/:id?page=${page}`,
      };
    if (posts.length < 20)
      return {
        posts,
        next: null,
        prev: `/api/post/contributed_posts/:id?page=${page}`,
      };

    let next: number = page;
    return {
      posts,
      next: `/api/post/contributed_posts/:id?page=${++next}`,
      prev: `/api/post/contributed_posts/:id?page=${page}`,
    };
  }

  async getBookmarkedPosts(page: number, id: string): Promise<any> {
    if (!id) throw new InternalServerErrorException('Sorry error occured');
    const user: User = await this.userService.getSingleUser(id);

    if (!user) throw new NotFoundException('User does not exist');
    if (!page) page = 0;
    const bookmarkedPosts: Post[] = await this.postModel
      .find()
      .where('_id')
      .in(user.bookmarked_posts)
      .sort({ _id: -1 })
      .skip(page * 20)
      .limit(20);

    if (!bookmarkedPosts)
      return { posts: [], next: null, prev: `/api/post/?page=${page}` };
    if (bookmarkedPosts.length < 20)
      return {
        posts: bookmarkedPosts,
        next: null,
        prev: `/api/post/?page=${page}`,
      };

    let next: number = page;
    return {
      posts: bookmarkedPosts,
      next: `/api/post/?page=${++next}`,
      prev: `/api/post/?page=${page}`,
    };
  }

  async bookmarkPost(id: string, postId: string): Promise<any> {
    if (!id) throw new InternalServerErrorException('Sorry  error occured');
    const user: User = await this.userService.getSingleUser(id);

    user.bookmarked_posts = [...user.bookmarked_posts, postId];
    return this.userService.updateUser(id, user);
  }

  async getMyPosts(page: number, id: string): Promise<any> {
    if (!page) page = 0;
    const posts: Post[] = await this.postModel
      .find({ user_id: id })
      .sort({ _id: -1 })
      .skip(page * 20)
      .limit(20);

    if (!posts)
      return { posts: [], next: null, prev: `/api/post/page=${page}` };
    if (posts.length < 20)
      return { posts, next: null, prev: `/api/post/page=${page}` };

    let next: number = page;
    return {
      posts,
      next: `/api/post/?page=${++next}`,
      prev: `/api/post/?page=${page}`,
    };
  }

  async createPost(createPost: CreatePost): Promise<Post> {
    const newPost = new this.postModel(createPost);
    const savedPost: Post = await newPost.save();
    if (!savedPost)
      throw new InternalServerErrorException('Sorry Error Occured');

    return savedPost;
  }

  async updatePost(updatePostModel: UpdatePost): Promise<Post> {
    const updatedPost = await this.postModel.findByIdAndUpdate(
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

    await this.pushNotificationService.createNotificationSingle(
      'Contribution added to your post',
      post.user_id,
    );

    if (!updatedPost)
      throw new InternalServerErrorException('Sorry Error Occured');
    return updatedPost;
  }
}
