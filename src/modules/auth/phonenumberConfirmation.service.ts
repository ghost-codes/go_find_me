import {
  Injectable,
  NotFoundException,
  ForbiddenException,
  UnauthorizedException,
} from '@nestjs/common';
import { SmsService } from '../sms/sms.service';
import { JwtService } from '@nestjs/jwt';
import { Model } from 'mongoose';
import { User, UserDocument } from 'src/global/user.schema';
import { InjectModel } from '@nestjs/mongoose';
import * as notp from 'notp';
import { Confirm } from './interfaces/confirm.interface';

@Injectable()
export class PhoneConfirmationService {
  constructor(
    private readonly smsService: SmsService,
    private jwtService: JwtService,

    @InjectModel(User.name) private readonly userModel: Model<UserDocument>,
  ) {}

  async sendVerification(phone_number: string): Promise<any> {
    const user: User = await this.userModel.findOne({
      phone_number: phone_number,
    });
    // if (!user) throw new NotFoundException('User does not exist');
    const confirmation_token = await this.generateConfirmaToken({
      phone_number: phone_number,
    });
    const otp = notp.totp.gen(confirmation_token.confirmation_token, {
      time: 600,
    });
    await this.smsService.intiatePhoneNumberVerification(
      phone_number,
      `Here is your verification code ${otp}`,
    );
    return confirmation_token;
  }

  async confirmUser(confirmEmail: Confirm) {
    const payload = await this.verifyConfirmationToken(
      confirmEmail.confirmation_token,
    );
    const user: User = await this.userModel.findOne({ phone_number: payload });
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
    return await this.userModel.findById(user.id);
  }

  async verifyConfirmationToken(token: string): Promise<string> {
    try {
      const payload = this.jwtService.verify(token);
      return payload.phone_number;
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
