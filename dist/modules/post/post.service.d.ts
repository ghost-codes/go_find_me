import { Post, PostDocument } from './schema/post.schema';
import { Model } from 'mongoose';
import { CreatePost, UpdatePost } from './interfaces/createpost.interface';
import { ImageUploadService } from '../image-upload/image-upload.service';
import { Connection } from 'mongoose';
import { ContributionDocument } from './schema/contribution.schema';
import { CreateContribution } from './interfaces/create_contribution.interface';
import { PushNotificationService } from '../push-notification/push-notification.service';
export declare class PostService {
    private readonly connection;
    private readonly postModel;
    private readonly imageUploadService;
    private readonly contributionModel;
    private readonly pushNotificationService;
    constructor(connection: Connection, postModel: Model<PostDocument>, imageUploadService: ImageUploadService, contributionModel: Model<ContributionDocument>, pushNotificationService: PushNotificationService);
    getPosts(page: number): Promise<any>;
    createPost(createPost: CreatePost): Promise<Post>;
    updatePost(updatePostModel: UpdatePost): Promise<Post>;
    deletePost(postId: string): Promise<boolean>;
    createContribution(createContribution: CreateContribution): Promise<Post>;
}
