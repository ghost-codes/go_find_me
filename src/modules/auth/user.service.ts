import {
  Injectable,
  InternalServerErrorException,
  UnauthorizedException,
  NotFoundException,
} from '@nestjs/common';
import { Model } from 'mongoose';
import { InjectModel } from '@nestjs/mongoose';
import { User, UserDocument } from 'src/global/user.schema';
import {
  AuthenticationResponse,
  UserReponseModel,
} from './interfaces/auth.interface';

@Injectable()
export class UserService {
  constructor(
    @InjectModel(User.name) private readonly userModel: Model<UserDocument>,
  ) {}

  async getSingleUser(id: string): Promise<User> {
    const user: User = await this.userModel.findById(id);

    if (!user) throw new NotFoundException('User not found');
    return user;
  }

  async updateUser(id: string, data: User): Promise<any> {
    const user: User = await this.userModel.findByIdAndUpdate(id, data);
    if (!user) throw new NotFoundException('User not found');
    const updatedUser:User = await this.userModel.findById(id);
    const response =  {
        username: updatedUser.username,
        email: updatedUser.email,
        id: updatedUser.id,
        phone_number: updatedUser.phone_number,
        confirmed_at: updatedUser.confirmed_at,
        bookmarked_posts: updatedUser.bookmarked_posts,
    };
    return { message: 'User updated' ,user:response};
  }
}
