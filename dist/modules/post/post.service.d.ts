import { Post, PostDocument } from './schema/post.schema';
import { Model } from 'mongoose';
import { CreatePost, UpdatePost } from './interfaces/createpost.interface';
import { ImageUploadService } from '../image-upload/image-upload.service';
import { Connection } from 'mongoose';
import { ContributionDocument } from './schema/contribution.schema';
import { CreateContribution } from './interfaces/create_contribution.interface';
import { PushNotificationService } from '../push-notification/push-notification.service';
import { UserService } from '../auth/user.service';
export declare class PostService {
    private readonly connection;
    private readonly postModel;
    private readonly contributionModel;
    private readonly userService;
    private readonly imageUploadService;
    private readonly pushNotificationService;
    constructor(connection: Connection, postModel: Model<PostDocument>, contributionModel: Model<ContributionDocument>, userService: UserService, imageUploadService: ImageUploadService, pushNotificationService: PushNotificationService);
    getPosts(page: number): Promise<any>;
    getOnePost(id: string): Promise<any>;
    getCommentsPosts(id: string): Promise<any>;
    getBookmarkedPosts(id: string): Promise<any>;
    getMyPosts(page: number, id: string): Promise<any>;
    createPost(createPost: CreatePost): Promise<Post>;
    updatePost(updatePostModel: UpdatePost): Promise<Post>;
    deletePost(postId: string): Promise<boolean>;
    createContribution(createContribution: CreateContribution): Promise<Post>;
}
