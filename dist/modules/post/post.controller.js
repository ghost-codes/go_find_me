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
exports.PostController = void 0;
const common_1 = require("@nestjs/common");
const jwt_guard_1 = require("../auth/guard/jwt.guard");
const bookmark_post_dto_1 = require("./dto/bookmark_post.dto");
const createPost_dto_1 = require("./dto/createPost.dto");
const create_contribution_dto_1 = require("./dto/create_contribution.dto");
const updatePost_dto_1 = require("./dto/updatePost.dto");
const post_service_1 = require("./post.service");
let PostController = class PostController {
    constructor(postService) {
        this.postService = postService;
    }
    getAllPosts(page) {
        return this.postService.getPosts(page);
    }
    getOnePost(id) {
        return this.postService.getOnePost(id);
    }
    getMyPost(id, page) {
        return this.postService.getMyPosts(page, id);
    }
    getCommentedPosts(page, id) {
        return this.postService.getCommentsPosts(page, id);
    }
    getBookMarkedPosts(page, id) {
        return this.postService.getBookmarkedPosts(page, id);
    }
    bookmarkPost(body, id) {
        return this.postService.bookmarkPost(id, body.postId);
    }
    unbookmarkPost(body, id) {
        return this.postService.unBookmarkPost(id, body.postId);
    }
    createPost(files, body) {
        return this.postService.createPost(body);
    }
    updatePost(body, postId) {
        console.log(body);
        return this.postService.updatePost(body);
    }
    deletePost(postId) {
        return this.postService.deletePost(postId);
    }
    crateContribution(createContribution) {
        return this.postService.createContribution(createContribution);
    }
};
__decorate([
    (0, common_1.Get)('?'),
    __param(0, (0, common_1.Query)('page')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number]),
    __metadata("design:returntype", Promise)
], PostController.prototype, "getAllPosts", null);
__decorate([
    (0, common_1.Get)('/single_post/:id'),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], PostController.prototype, "getOnePost", null);
__decorate([
    (0, common_1.UseGuards)(jwt_guard_1.JwtAuthGuard),
    (0, common_1.Get)('/myposts/:id?'),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Query)('page')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, Number]),
    __metadata("design:returntype", Promise)
], PostController.prototype, "getMyPost", null);
__decorate([
    (0, common_1.Get)('/contributed_posts/:id?'),
    __param(0, (0, common_1.Query)('page')),
    __param(1, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number, String]),
    __metadata("design:returntype", Promise)
], PostController.prototype, "getCommentedPosts", null);
__decorate([
    (0, common_1.UseGuards)(jwt_guard_1.JwtAuthGuard),
    (0, common_1.Get)('/bookmarked_posts/:id?'),
    __param(0, (0, common_1.Query)('page')),
    __param(1, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number, String]),
    __metadata("design:returntype", Promise)
], PostController.prototype, "getBookMarkedPosts", null);
__decorate([
    (0, common_1.UseGuards)(jwt_guard_1.JwtAuthGuard),
    (0, common_1.Post)('/bookmark_post/:userId'),
    __param(0, (0, common_1.Body)()),
    __param(1, (0, common_1.Param)('userId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [bookmark_post_dto_1.BookmarkPostDTO, String]),
    __metadata("design:returntype", void 0)
], PostController.prototype, "bookmarkPost", null);
__decorate([
    (0, common_1.UseGuards)(jwt_guard_1.JwtAuthGuard),
    (0, common_1.Post)('/unbookmark_post/:userId'),
    __param(0, (0, common_1.Body)()),
    __param(1, (0, common_1.Param)('userId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [bookmark_post_dto_1.BookmarkPostDTO, String]),
    __metadata("design:returntype", void 0)
], PostController.prototype, "unbookmarkPost", null);
__decorate([
    (0, common_1.UseGuards)(jwt_guard_1.JwtAuthGuard),
    (0, common_1.Post)(),
    __param(0, (0, common_1.UploadedFiles)()),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, createPost_dto_1.CreatePostDTO]),
    __metadata("design:returntype", void 0)
], PostController.prototype, "createPost", null);
__decorate([
    (0, common_1.UseGuards)(jwt_guard_1.JwtAuthGuard),
    (0, common_1.Put)(':postId'),
    __param(0, (0, common_1.Body)()),
    __param(1, (0, common_1.Param)('postId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [updatePost_dto_1.UpdatePostDTO, String]),
    __metadata("design:returntype", void 0)
], PostController.prototype, "updatePost", null);
__decorate([
    (0, common_1.UseGuards)(jwt_guard_1.JwtAuthGuard),
    (0, common_1.Delete)('delete_post/:postId'),
    __param(0, (0, common_1.Param)('postId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", void 0)
], PostController.prototype, "deletePost", null);
__decorate([
    (0, common_1.UseGuards)(jwt_guard_1.JwtAuthGuard),
    (0, common_1.Post)('create_contribution'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [create_contribution_dto_1.CreateContributionDTO]),
    __metadata("design:returntype", Promise)
], PostController.prototype, "crateContribution", null);
PostController = __decorate([
    (0, common_1.Controller)('api/post'),
    __metadata("design:paramtypes", [post_service_1.PostService])
], PostController);
exports.PostController = PostController;
//# sourceMappingURL=post.controller.js.map