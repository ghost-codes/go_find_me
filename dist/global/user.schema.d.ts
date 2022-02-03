import { Document } from 'mongoose';
export declare type UserDocument = User & Document;
export declare class User extends Document {
    username: string;
    email: string;
    phone_number: string;
    confirmed_at: Date;
    password: string;
    passHash: string;
}
export declare const UserSchema: import("mongoose").Schema<User, import("mongoose").Model<User, any, any, any>, {}>;
