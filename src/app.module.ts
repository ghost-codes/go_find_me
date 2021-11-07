import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { MongooseModule } from '@nestjs/mongoose';
import { AuthModule } from './modules/auth/auth.module';
import { PostModule } from './modules/post/post.module';
import config from './config/keys';

import { ImageUploadModule } from './modules/image-upload/image-upload.module';
import { ConfigModule } from '@nestjs/config';

@Module({
  imports: [
    PostModule,
    AuthModule,
    MongooseModule.forRoot(config.mongoURI),
    ConfigModule.forRoot({
      isGlobal: true,
    }),

    ImageUploadModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
