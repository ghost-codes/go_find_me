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
exports.ImageUploadService = void 0;
const common_1 = require("@nestjs/common");
const multer = require("multer");
const AWS = require("aws-sdk");
const multerS3 = require("multer-s3");
const s3 = new AWS.S3();
AWS.config.update({
    accessKeyId: process.env.AWS_ACCESS_KEY_ID,
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
});
let ImageUploadService = class ImageUploadService {
    constructor() {
        this.upload = multer({
            storage: multerS3({
                s3: s3,
                bucket: 'gofindmepostimages',
                acl: 'public-read',
                key: function (request, file, cb) {
                    cb(null, `${Date.now().toString()}-${file.originalname}`);
                },
            }),
        }).array('upload', 8);
    }
    async fileupload(req, res) {
        try {
            this.upload(req, res, function (error) {
                if (error) {
                    console.log(error);
                    return res.status(404).json(`Failed to upload image file: ${error}`);
                }
                const paths = [];
                req.files.forEach((element) => {
                    paths.push(`file/${element.key}`);
                });
                return res.status(201).json(paths);
            });
        }
        catch (error) {
            console.log(error);
            return res.status(500).json(`Failed to upload image file: ${error}`);
        }
    }
    async getFile(key) {
        const stream = await s3
            .getObject({
            Bucket: process.env.AWS_S3_BUCKET_NAME,
            Key: key,
        })
            .createReadStream();
        if (!stream)
            throw new common_1.NotFoundException('Resource Not Found');
        return stream;
    }
    async deleteFiles(keys) {
        const keyObject = [];
        keys.forEach((element) => {
            keyObject.push({ Key: element });
        });
        await s3.deleteObjects({
            Bucket: process.env.AWS_S3_BUCKET_NAME,
            Delete: { Objects: keyObject },
        }, (err, data) => {
            if (err)
                throw new common_1.InternalServerErrorException(`Failed to upload image file: ${err}`);
            return true;
        });
    }
};
__decorate([
    __param(0, (0, common_1.Req)()),
    __param(1, (0, common_1.Res)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, Object]),
    __metadata("design:returntype", Promise)
], ImageUploadService.prototype, "fileupload", null);
ImageUploadService = __decorate([
    (0, common_1.Injectable)()
], ImageUploadService);
exports.ImageUploadService = ImageUploadService;
//# sourceMappingURL=image-upload.service.js.map