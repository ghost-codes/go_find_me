import {
  Req,
  Res,
  Injectable,
  NotFoundException,
  InternalServerErrorException,
} from '@nestjs/common';
import * as multer from 'multer';
import * as AWS from 'aws-sdk';
import * as multerS3 from 'multer-s3';

const s3 = new AWS.S3();
AWS.config.update({
  accessKeyId: process.env.AWS_ACCESS_KEY_ID,
  secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
});

@Injectable()
export class ImageUploadService {
  async fileupload(@Req() req, @Res() res) {
    try {
      this.upload(req, res, function (error) {
        if (error) {
          console.log(error);
          return res.status(404).json(`Failed to upload image file: ${error}`);
        }
        const paths: string[] = [];
        req.files.forEach((element) => {
          paths.push(`file/${element.key}`);
        });
        return res.status(201).json(paths);
      });
    } catch (error) {
      console.log(error);
      return res.status(500).json(`Failed to upload image file: ${error}`);
    }
  }
  async getFile(key: string) {
    const stream = await s3
      .getObject({
        Bucket: process.env.AWS_S3_BUCKET_NAME,
        Key: key,
      })
      .createReadStream();
    if (!stream) throw new NotFoundException('Resource Not Found');
    return stream;
  }

  async deleteFile(keys: string[]): Promise<any> {
    const keyObject = [];
    keys.forEach((element) => {
      keyObject.push({ Key: element });
    });

    await s3.deleteObjects(
      {
        Bucket: process.env.AWS_S3_BUCKET_NAME,
        Delete: { Objects: keyObject },
      },
      (err, data) => {
        if (err)
          throw new InternalServerErrorException(
            `Failed to upload image file: ${err}`,
          );

        return true;
      },
    );
  }

  upload = multer({
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
