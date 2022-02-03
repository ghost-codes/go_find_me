import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { MongooseModule } from '@nestjs/mongoose';
import { AuthModule } from './modules/auth/auth.module';
import { PostModule } from './modules/post/post.module';

import { ImageUploadModule } from './modules/image-upload/image-upload.module';
import { ConfigModule } from '@nestjs/config';
import { MailerModule } from '@nestjs-modules/mailer';
import { PugAdapter } from '@nestjs-modules/mailer/dist/adapters/pug.adapter';
import { PushNotificationModule } from './modules/push-notification/push-notification.module';
import { OneSignalModule } from 'onesignal-api-client-nest';

@Module({
  imports: [
    ConfigModule.forRoot(),
    OneSignalModule.forRoot({
      appId: process.env.ONE_SIGNAL_APP_ID,
      restApiKey: process.env.ONE_SIGNAL_API_KEY,
    }),
    MailerModule.forRoot({
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
        adapter: new PugAdapter(),
        options: {
          strict: true,
        },
      },
    }),
    PostModule,
    AuthModule,
    MongooseModule.forRoot(process.env.MONGO_URI),
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    ImageUploadModule,
    PushNotificationModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
