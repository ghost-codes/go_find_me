import { Injectable } from '@nestjs/common';
import {
  MulterModuleOptions,
  MulterOptionsFactory,
} from '@nestjs/platform-express';

import { MongoGridFS } from 'mongo-gridfs';
import { GridFsStorage } from 'multer-gridfs-storage';
import config from '../../config/keys';

@Injectable()
export class GridFsMulterConfigeService implements MulterOptionsFactory {
  gridFsStorage: any;

  constructor() {
    this.gridFsStorage = new GridFsStorage({
      url: config.mongoURI,
      file: (req, file) => {
        return new Promise((resolve, reject) => {
          const filename = file.originalname.trim();
          const fileInfo = {
            filename: filename,
          };
          resolve(fileInfo);
        });
      },
    });
  }

  createMulterOptions(): MulterModuleOptions {
    return { storage: this.gridFsStorage };
  }
}
