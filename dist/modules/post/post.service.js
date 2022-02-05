"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.PostService = void 0;
const common_1 = require("@nestjs/common");
const post_schema_1 = require("./schema/post.schema");
const mongoose_1 = require("@nestjs/mongoose");
const mongoose_2 = require("mongoose");
const mongoose_3 = require("@nestjs/mongoose");
const image_upload_service_1 = require("../image-upload/image-upload.service");
const mongoose_4 = require("mongoose");
const contribution_schema_1 = require("./schema/contribution.schema");
const push_notification_service_1 = require("../push-notification/push-notification.service");
const user_service_1 = require("../auth/user.service");
const user_schema_1 = require("../../global/user.schema");
let PostService = class PostService {
    constructor(connection, postModel, contributionModel, userService, imageUploadService, pushNotificationService) {
        this.connection = connection;
        this.postModel = postModel;
        this.contributionModel = contributionModel;
        this.userService = userService;
        this.imageUploadService = imageUploadService;
        this.pushNotificationService = pushNotificationService;
    }
    async getPosts(page) {
        if (!page)
            page = 0;
        const posts = await this.postModel
            .find()
            .sort({ _id: -1 })
            .skip(page * 20)
            .limit(20);
        if (!posts)
            return { posts: [], next: null, prev: `/api/post/page=${page}` };
        if (posts.length < 20)
            return { posts, next: null, prev: `/api/post/page=${page}` };
        let next = page;
        return {
            posts,
            next: `/api/post/?page=${++next}`,
            prev: `/api/post/?page=${page}`,
        };
    }
    async getOnePost(id) {
        if (!id)
            throw new common_1.InternalServerErrorException('Sorry Error Occured');
        const post = await this.postModel.findById(id);
        if (!post)
            throw new common_1.NotFoundException('Post not found');
        return { message: 'Success', post: post };
    }
    async getCommentsPosts(id) {
        if (!id)
            throw new common_1.InternalServerErrorException('Sorry Error Occured');
        const post = await this.postModel.find({ contributions: id });
        if (!post)
            return { posts: [] };
        return { posts: post };
    }
    async getBookmarkedPosts(id) {
        if (!id)
            throw new common_1.InternalServerErrorException('Sorry error occured');
        const user = await this.userService.getSingleUser(id);
        if (!user)
            throw new common_1.NotFoundException('User does not exist');
        console.log(user.bookmarked_posts);
        const bookmarkedPosts = await this.postModel
            .find()
            .where('_id')
            .in(user.bookmarked_posts);
        if (!bookmarkedPosts)
            return { posts: [] };
        return { posts: bookmarkedPosts };
    }
    async getMyPosts(page, id) {
        if (!page)
            page = 0;
        const posts = await this.postModel
            .find({ user_id: id })
            .sort({ _id: -1 })
            .skip(page * 20)
            .limit(20);
        if (!posts)
            return { posts: [], next: null, prev: `/api/post/page=${page}` };
        if (posts.length < 20)
            return { posts, next: null, prev: `/api/post/page=${page}` };
        let next = page;
        return {
            posts,
            next: `/api/post/?page=${++next}`,
            prev: `/api/post/?page=${page}`,
        };
    }
    async createPost(createPost) {
        const newPost = new this.postModel(createPost);
        const savedPost = await newPost.save();
        if (!savedPost)
            throw new common_1.InternalServerErrorException('Sorry Error Occured');
        return savedPost;
    }
    async updatePost(updatePostModel) {
        const updatedPost = await this.postModel.findByIdAndUpdate(updatePostModel.id, updatePostModel);
        if (!updatedPost)
            throw new common_1.NotFoundException('Post not found');
        return updatedPost;
    }
    async deletePost(postId) {
        const post = await this.postModel.findById(postId);
        const keys = [];
        post.imgs.forEach(async (imagePath) => {
            const pathSections = imagePath.split('/');
            console.log(pathSections);
            keys.push(pathSections.pop());
        });
        await this.imageUploadService.deleteFiles(keys);
        post.contributions.forEach(async (element) => await this.contributionModel.findByIdAndDelete(element));
        const deletedPost = await this.postModel.findByIdAndDelete(postId);
        if (!deletedPost)
            throw new common_1.InternalServerErrorException('Error Could not delete post');
        return true;
    }
    async createContribution(createContribution) {
        const newContribution = new this.contributionModel(createContribution);
        const savedContribution = await newContribution.save();
        if (!savedContribution)
            throw new common_1.InternalServerErrorException('Sorry Error Occured');
        const post = await this.postModel.findById(savedContribution.post_id);
        post.contributions = [...post.contributions, savedContribution.id];
        const updatedPost = await this.postModel.findByIdAndUpdate(savedContribution.post_id, post);
        await this.pushNotificationService.createNotificationSingle('Contribution added to your post', post.user_id);
        if (!updatedPost)
            throw new common_1.InternalServerErrorException('Sorry Error Occured');
        return updatedPost;
    }
};
PostService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, mongoose_3.InjectConnection)()),
    __param(1, (0, mongoose_1.InjectModel)(post_schema_1.Post.name)),
    __param(2, (0, mongoose_1.InjectModel)(contribution_schema_1.Contribution.name)),
    __metadata("design:paramtypes", [mongoose_4.Connection,
        mongoose_2.Model,
        mongoose_2.Model,
        user_service_1.UserService,
        image_upload_service_1.ImageUploadService,
        push_notification_service_1.PushNotificationService])
], PostService);
exports.PostService = PostService;
//# sourceMappingURL=post.service.js.map