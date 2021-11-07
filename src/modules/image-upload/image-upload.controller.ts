import { Controller, Get, Param, Post, Req, Res } from '@nestjs/common';
import { ApiBody, ApiConsumes } from '@nestjs/swagger';
import { ImageUploadService } from './image-upload.service';

@ApiConsumes('multipart/form-data')
@Controller('file')
export class ImageUploadController {
  constructor(private readonly imageUploadService: ImageUploadService) {}
  @Post()
  async create(@Req() request, @Res() response) {
    try {
      return await this.imageUploadService.fileupload(request, response);
    } catch (error) {
      return response
        .status(500)
        .json(`Failed to upload image file: ${error.message}`);
    }
  }

  @Get(':key')
  async get(@Param('key') key: string, @Res() res) {
    const stream = await this.imageUploadService.getFile(key);
    return stream.pipe(res);
  }
}
