import { User, UserDocument } from '../../global/user.schema';
import { JwtService } from '@nestjs/jwt';
import { Model } from 'mongoose';
import { MailerService } from '@nestjs-modules/mailer';
import { Confirm } from './interfaces/confirm.interface';
export declare class EmailConfirmationService {
    private jwtService;
    private mailerService;
    private readonly userModel;
    constructor(jwtService: JwtService, mailerService: MailerService, userModel: Model<UserDocument>);
    sendVerification(email: string): Promise<any>;
    sendForgotPasswordCode(email: string): Promise<any>;
    sendVerificationEmail(user: User, otp: string): Promise<void>;
    verifyForgotPasswordCode(forgotPassCode: Confirm): Promise<{
        message: string;
        token: any;
    }>;
    confirmUser(confirmEmail: Confirm): Promise<{
        id: any;
        phone_number: string;
        confirmed_at: Date;
        email: string;
        username: string;
    }>;
    verifyConfirmationToken(token: string): Promise<any>;
    generateConfirmaToken(payload: any): Promise<any>;
}
