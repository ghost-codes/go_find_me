"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AppModule = void 0;
const common_1 = require("@nestjs/common");
const app_controller_1 = require("./app.controller");
const app_service_1 = require("./app.service");
const mongoose_1 = require("@nestjs/mongoose");
const auth_module_1 = require("./modules/auth/auth.module");
const post_module_1 = require("./modules/post/post.module");
const image_upload_module_1 = require("./modules/image-upload/image-upload.module");
const config_1 = require("@nestjs/config");
const mailer_1 = require("@nestjs-modules/mailer");
const pug_adapter_1 = require("@nestjs-modules/mailer/dist/adapters/pug.adapter");
const push_notification_module_1 = require("./modules/push-notification/push-notification.module");
const onesignal_api_client_nest_1 = require("onesignal-api-client-nest");
let AppModule = class AppModule {
};
AppModule = __decorate([
    (0, common_1.Module)({
        imports: [
            config_1.ConfigModule.forRoot(),
            onesignal_api_client_nest_1.OneSignalModule.forRoot({
                appId: process.env.ONE_SIGNAL_APP_ID,
                restApiKey: process.env.ONE_SIGNAL_API_KEY,
            }),
            mailer_1.MailerModule.forRoot({
                transport: {
                    host: 'smtp.sendgrid.net',
                    port: 587,
                    secure: false,
                    auth: {
                        user: 'apikey',
                        pass: process.env.SENDGRID_APIKEY_PASS,
                    },
                },
                defaults: {
                    from: process.env.EMAIL_SENDER,
                },
                template: {
                    dir: __dirname + '/templates/',
                    adapter: new pug_adapter_1.PugAdapter(),
                    options: {
                        strict: true,
                    },
                },
            }),
            post_module_1.PostModule,
            auth_module_1.AuthModule,
            mongoose_1.MongooseModule.forRoot(process.env.MONGO_URI),
            config_1.ConfigModule.forRoot({
                isGlobal: true,
            }),
            image_upload_module_1.ImageUploadModule,
            push_notification_module_1.PushNotificationModule,
        ],
        controllers: [app_controller_1.AppController],
        providers: [app_service_1.AppService],
    })
], AppModule);
exports.AppModule = AppModule;
//# sourceMappingURL=app.module.js.map