import { SmsService } from '../sms/sms.service';
import { JwtService } from '@nestjs/jwt';
import { Model } from 'mongoose';
import { UserDocument } from 'src/global/user.schema';
import { Confirm } from './interfaces/confirm.interface';
export declare class PhoneConfirmationService {
    private readonly smsService;
    private jwtService;
    private readonly userModel;
    constructor(smsService: SmsService, jwtService: JwtService, userModel: Model<UserDocument>);
    sendVerification(phone_number: string): Promise<any>;
    confirmUser(confirmEmail: Confirm): Promise<{
        id: any;
        phone_number: string;
        confirmed_at: Date;
        email: string;
        username: string;
    }>;
    verifyConfirmationToken(token: string): Promise<string>;
    generateConfirmaToken(payload: any): Promise<any>;
}
