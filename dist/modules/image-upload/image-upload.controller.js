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
exports.ImageUploadController = void 0;
const common_1 = require("@nestjs/common");
const swagger_1 = require("@nestjs/swagger");
const deleteImage_dto_1 = require("./dtos/deleteImage.dto");
const image_upload_service_1 = require("./image-upload.service");
let ImageUploadController = class ImageUploadController {
    constructor(imageUploadService) {
        this.imageUploadService = imageUploadService;
    }
    async create(request, response) {
        try {
            return await this.imageUploadService.fileupload(request, response);
        }
        catch (error) {
            return response
                .status(500)
                .json(`Failed to upload image file: ${error.message}`);
        }
    }
    async deleteFiles(imagePaths) {
        const imageKeys = [];
        imagePaths.imgs.forEach(async (imagePath) => {
            const pathSections = imagePath.split('/');
            imageKeys.push(pathSections.pop());
        });
        return this.imageUploadService.deleteFiles(imageKeys);
    }
    async get(key, res) {
        const stream = await this.imageUploadService.getFile(key);
        return stream.pipe(res);
    }
};
__decorate([
    (0, common_1.Post)(),
    __param(0, (0, common_1.Req)()),
    __param(1, (0, common_1.Res)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, Object]),
    __metadata("design:returntype", Promise)
], ImageUploadController.prototype, "create", null);
__decorate([
    (0, common_1.Delete)('delete'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [deleteImage_dto_1.DeleteImageDTO]),
    __metadata("design:returntype", Promise)
], ImageUploadController.prototype, "deleteFiles", null);
__decorate([
    (0, common_1.Get)(':key'),
    __param(0, (0, common_1.Param)('key')),
    __param(1, (0, common_1.Res)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, Object]),
    __metadata("design:returntype", Promise)
], ImageUploadController.prototype, "get", null);
ImageUploadController = __decorate([
    (0, swagger_1.ApiConsumes)('multipart/form-data'),
    (0, common_1.Controller)('file'),
    __metadata("design:paramtypes", [image_upload_service_1.ImageUploadService])
], ImageUploadController);
exports.ImageUploadController = ImageUploadController;
//# sourceMappingURL=image-upload.controller.js.map