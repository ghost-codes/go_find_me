import { Module } from '@nestjs/common';
import { MulterModule } from '@nestjs/platform-express';
import { FilesController } from './files.conroller';
import { FileService } from './files.service';
import { GridFsMulterConfigeService } from './gridfs.config';
// import {fi}

@Module({
  imports: [
    MulterModule.registerAsync({
      useClass: GridFsMulterConfigeService,
    }),
  ],
  controllers: [FilesController],
  providers: [GridFsMulterConfigeService, FileService],
})
export class FilesModule {}
