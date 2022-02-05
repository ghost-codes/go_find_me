import {
  Injectable,
  InternalServerErrorException,
  UnauthorizedException,
  NotFoundException,
} from '@nestjs/common';
import { Model } from 'mongoose';
import { InjectModel } from '@nestjs/mongoose';
import { User, UserDocument } from 'src/global/user.schema';

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
    return { message: 'User updated' };
  }
}
