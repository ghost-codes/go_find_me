import { Injectable, UnauthorizedException } from '@nestjs/common';
import {
  AuthenticationResponse,
  UserReponseModel,
} from './interfaces/auth.interface';
import { Model } from 'mongoose';
import { InjectModel } from '@nestjs/mongoose';
import { User, UserDocument } from 'src/global/user.schema';
import { SignUpDTO } from './dto/signUp.dto';
import { JwtService } from '@nestjs/jwt';
import { UserSession } from './interfaces/userSession.interface';
import { LoginEmailDTO } from './dto/login.dto';
import * as bcrypt from 'bcrypt';

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
    const refresh_token = await this.generateRefreshToken(savedUser);

    const response: AuthenticationResponse = {
      user: {
        username: userResponse.username,
        email: userResponse.email,
        id: userResponse.id,
      },
      accessToken: access_token.access_token,
      refreshToken: refresh_token.refresh_token,
    };
    console.log(response);
    return response;
  }

  async emailLogin(loginDTO: LoginEmailDTO): Promise<any> {
    const user: User = await this.userModel.findOne({
      $or: [{ username: loginDTO.identity }, { email: loginDTO.identity }],
    });

    if (!user) throw new UnauthorizedException('Invalid email or password');
    if (!(await this.bcryptCompare(loginDTO.password, user.password)))
      throw new UnauthorizedException('Invalid email or password');

    const accessToken = await this.generateAccessToken(user);
    const refreshToken = await this.generateRefreshToken(user);
    const response: AuthenticationResponse = {
      user: {
        username: user.username,
        email: user.email,
        id: user.id,
      },
      accessToken: accessToken.access_token,
      refreshToken: refreshToken.refresh_token,
    };
    console.log(response);
    return response;
  }

  async refreshAccessToken(refreshToken: string): Promise<UserSession> {
    const payload = this.validateToken(refreshToken);
    if (!payload) throw new UnauthorizedException('Unathorized credentials');
    const accessToken = await this.generateAccessToken(payload);
    const userSession: UserSession = {
      accessToken: accessToken.access_token,
      refreshToken: refreshToken,
    };
    return userSession;
  }

  async validateToken(token: string) {
    try {
      const result = this.jwtService.verifyAsync(token);
      return result;
    } catch (e) {}
    return null;
  }

  async bcryptCompare(passwordString: string, hash: string): Promise<boolean> {
    return await bcrypt.compare(passwordString, hash);
  }

  async generateAccessToken(user: any) {
    const payload = { username: user.username, sub: user.id };
    return {
      access_token: this.jwtService.sign(payload),
    };
  }

  async generateRefreshToken(user: User) {
    const payload = { username: user.username, sub: user.id };
    return {
      refresh_token: this.jwtService.sign(payload, { expiresIn: '500d' }),
    };
  }
}
