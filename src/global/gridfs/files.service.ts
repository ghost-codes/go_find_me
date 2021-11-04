import { Injectable } from '@nestjs/common';
import { InjectConnection } from '@nestjs/mongoose';
import { MongoGridFS } from 'mongo-gridfs';
import { Connection } from 'mongoose';

@Injectable()
export class FileService {
  private fileModel: MongoGridFS;

  constructor(@InjectConnection() private readonly connection: Connection) {
    this.fileModel = new MongoGridFS(this.connection.db, 'fs');
  }

  async writeFile(file, metadata): Promise<any> {
    return await this.fileModel.uploadFile(
      file.path,
      {
        filename: file.originalname,
        contentType: file.mimetype,
        metadata: metadata,
      },
      true,
    );
  }
}
