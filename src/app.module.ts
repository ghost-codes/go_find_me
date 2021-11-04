import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { MongooseModule } from '@nestjs/mongoose';
import { AuthModule } from './modules/auth/auth.module';
import { PostModule } from './modules/post/post.module';
import config from './config/keys';
import { FilesModule } from './global/gridfs/files.module';

@Module({
  imports: [
    PostModule,
    AuthModule,
    MongooseModule.forRoot(config.mongoURI),
    FilesModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
