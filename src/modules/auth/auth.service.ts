import { Injectable } from '@nestjs/common';
import { AuthenticationResponse, UserReponseModel } from './auth.interface';
import { Model } from 'mongoose';
import { InjectModel } from '@nestjs/mongoose';
import { User, UserDocument } from 'src/global/user.schema';
import { SignUpDTO } from './dto/signUp.dto';
import { JwtService } from '@nestjs/jwt';

@Injectable()
export class AuthService {
  constructor(
    @InjectModel(User.name) private readonly userModel: Model<UserDocument>,
    private jwtService: JwtService,
  ) {}

  async validateUser(
    username: string,
    pass: string,
  ): Promise<UserReponseModel | null> {
    const user = await this.userModel.findOne({ username: username });

    if (user && user.password === pass) {
      const userResponseModel: UserReponseModel = user;
      return userResponseModel;
    }
    return null;
  }

  async emailSignup(signUpDto: SignUpDTO): Promise<any> {
    const newUser = new this.userModel(signUpDto);
    const savedUser = await newUser.save();
    const userResponse: UserReponseModel = savedUser;

    const access_token = await this.generateAccessToken(savedUser);
    const response: AuthenticationResponse = {
      user: {
        username: userResponse.username,
        email: userResponse.email,
        id: userResponse.id,
      },
      accessToken: access_token.access_token,
      refreshToken: '',
    };
    console.log(response);
    return response;
  }

  // async

  async generateAccessToken(user: UserDocument) {
    const payload = { username: user.username, sub: user.id };
    return {
      access_token: this.jwtService.sign(payload),
    };
  }
}
