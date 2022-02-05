import { Model } from 'mongoose';
import { User, UserDocument } from 'src/global/user.schema';
export declare class UserService {
    private readonly userModel;
    constructor(userModel: Model<UserDocument>);
    getSingleUser(id: string): Promise<User>;
    updateUser(id: string, data: User): Promise<any>;
}
