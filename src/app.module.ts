import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { MongooseModule } from '@nestjs/mongoose';
import { AuthModule } from './modules/auth/auth.module';
import { PostModule } from './modules/post/post.module';
import config from './config/keys';

@Module({
  imports: [PostModule, AuthModule, MongooseModule.forRoot(config.mongoURI)],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
