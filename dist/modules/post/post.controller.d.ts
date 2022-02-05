import { CreatePostDTO } from './dto/createPost.dto';
import { CreateContributionDTO } from './dto/create_contribution.dto';
import { UpdatePostDTO } from './dto/updatePost.dto';
import { PostService } from './post.service';
export declare class PostController {
    private postService;
    constructor(postService: PostService);
    getAllPosts(page: number): Promise<any>;
    getOnePost(id: string): Promise<any>;
    getMyPost(id: string, page: number): Promise<any>;
    getCommentedPosts(id: string): Promise<any>;
    getBookMarkedPosts(id: string): Promise<any>;
    createPost(files: any, body: CreatePostDTO): Promise<import("./schema/post.schema").Post>;
    updatePost(body: UpdatePostDTO, postId: string): Promise<import("./schema/post.schema").Post>;
    deletePost(postId: string): Promise<boolean>;
    crateContribution(createContribution: CreateContributionDTO): Promise<any>;
}
