/// <reference types="node" />
/// <reference types="qs" />
/// <reference types="express" />
export declare class ImageUploadService {
    fileupload(req: any, res: any): Promise<any>;
    getFile(key: string): Promise<import("stream").Readable>;
    deleteFiles(keys: string[]): Promise<any>;
    upload: import("express").RequestHandler<import("express-serve-static-core").ParamsDictionary, any, any, import("qs").ParsedQs, Record<string, any>>;
}
