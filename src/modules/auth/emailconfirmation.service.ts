import {
  Injectable,
  ForbiddenException,
  NotFoundException,
  InternalServerErrorException,
  UnauthorizedException,
} from '@nestjs/common';
import * as notp from 'notp';
import { User, UserDocument } from '../../global/user.schema';
import { JwtService } from '@nestjs/jwt';
import { Model } from 'mongoose';
import { InjectModel } from '@nestjs/mongoose';
import { MailerService } from '@nestjs-modules/mailer';
import { Confirm } from './interfaces/confirm.interface';

@Injectable()
export class EmailConfirmationService {
  constructor(
    private jwtService: JwtService,
    private mailerService: MailerService,
    @InjectModel(User.name) private readonly userModel: Model<UserDocument>,
  ) {}

  async sendVerification(email: string): Promise<any> {
    const user: User = await this.userModel.findOne({ email: email });
    if (!user) throw new NotFoundException('User does not exist');
    const confirmation_token = await this.generateConfirmaToken({
      email: email,
    });
    const otp = notp.totp.gen(confirmation_token.confirmation_token, {
      time: 600,
    });
    await this.sendVerificationEmail(user, otp);
    return confirmation_token;
  }

  async sendVerificationEmail(user: User, otp: string): Promise<void> {
    await this.mailerService
      .sendMail({
        to: user.email,
        from: process.env.EMAIL_SENDER,
        subject: 'Testing',
        text: otp,
        template: 'dist/src/templates/emailconfirmation',
        context: { name: user.username, code: otp },
      })
      .then(() => {})
      .catch((e) => {
        console.log(e);
        throw new InternalServerErrorException();
      });
  }

  async confirmUser(confirmEmail: Confirm) {
    const payload = await this.verifyConfirmationToken(
      confirmEmail.confirmation_token,
    );
    const user: User = await this.userModel.findOne({ email: payload });
    if (!user) throw new NotFoundException('User not found');
    const is_verified = notp.totp.verify(
      confirmEmail.otp,
      confirmEmail.confirmation_token,
      { time: 600 },
    );
    console.log(is_verified);

    if (!is_verified) throw new UnauthorizedException('Wrong passcode');
    await this.userModel.findByIdAndUpdate(user.id, {
      confirmed_at: new Date(Date.now()),
    });
    const updatedUser: User = await this.userModel.findById(user.id);
    return {
      id: updatedUser.id,
      phone_number: updatedUser.phone_number,
      confirmed_at: updatedUser.confirmed_at,
      email: updatedUser.email,
      username: updatedUser.username,
    };
  }

  async verifyConfirmationToken(token: string): Promise<string> {
    try {
      const payload = this.jwtService.verify(token);
      return payload.email;
    } catch (e) {
      throw new ForbiddenException('Invalid Token');
    }
  }

  async generateConfirmaToken(payload: any): Promise<any> {
    return {
      confirmation_token: this.jwtService.sign(payload, { expiresIn: '10m' }),
    };
  }
}
