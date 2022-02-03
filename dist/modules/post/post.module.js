"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.PostModule = void 0;
const common_1 = require("@nestjs/common");
const mongoose_1 = require("@nestjs/mongoose");
const passport_1 = require("@nestjs/passport");
const image_upload_module_1 = require("../image-upload/image-upload.module");
const image_upload_service_1 = require("../image-upload/image-upload.service");
const push_notification_module_1 = require("../push-notification/push-notification.module");
const post_controller_1 = require("./post.controller");
const post_service_1 = require("./post.service");
const contribution_schema_1 = require("./schema/contribution.schema");
const post_schema_1 = require("./schema/post.schema");
let PostModule = class PostModule {
};
PostModule = __decorate([
    (0, common_1.Module)({
        imports: [
            mongoose_1.MongooseModule.forFeatureAsync([
                {
                    name: post_schema_1.Post.name,
                    useFactory: () => {
                        const schema = post_schema_1.PostSchema;
                        return schema;
                    },
                },
            ]),
            mongoose_1.MongooseModule.forFeatureAsync([
                {
                    name: contribution_schema_1.Contribution.name,
                    useFactory: () => {
                        const schema = contribution_schema_1.ContributionSchema;
                        return schema;
                    },
                },
            ]),
            passport_1.PassportModule.register({ defaultStrategy: 'jwt' }),
            image_upload_service_1.ImageUploadService,
            image_upload_module_1.ImageUploadModule,
            push_notification_module_1.PushNotificationModule,
        ],
        controllers: [post_controller_1.PostController],
        providers: [post_service_1.PostService],
    })
], PostModule);
exports.PostModule = PostModule;
//# sourceMappingURL=post.module.js.map