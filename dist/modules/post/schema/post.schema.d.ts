import { Document } from 'mongoose';
export declare type PostDocument = Post & Document;
export declare class Post extends Document {
    user_id: string;
    imgs: string[];
    title: string;
    desc: string;
    contributions: string[];
    privilleged: string[];
    shares: number;
    last_seen: Record<string, any>;
    status: string;
    created_at: Date;
    updated_at: Date;
}
export declare const PostSchema: import("mongoose").Schema<Post, import("mongoose").Model<Post, any, any, any>, {}>;
