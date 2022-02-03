import { DeleteImageDTO } from './dtos/deleteImage.dto';
import { ImageUploadService } from './image-upload.service';
export declare class ImageUploadController {
    private readonly imageUploadService;
    constructor(imageUploadService: ImageUploadService);
    create(request: any, response: any): Promise<any>;
    deleteFiles(imagePaths: DeleteImageDTO): Promise<any>;
    get(key: string, res: any): Promise<any>;
}
