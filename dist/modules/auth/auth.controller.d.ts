import { SignUpDTO } from './dto/signUp.dto';
import { AuthService } from './auth.service';
import { LoginEmailDTO } from './dto/login.dto';
import { RefreshTokenDTO } from './dto/refreshToken.dto';
import { EmailConfirmationService } from './emailconfirmation.service';
import { ConfirmDTO } from './dto/confirm.dto';
import { SendOtpDTO } from './dto/sendOtp.dto';
import { SendPhoneOtpDTO } from './dto/sendPhoneOtp.dto';
import { PhoneConfirmationService } from './phonenumberConfirmation.service';
import { SendCodeForgottenPassword } from './dto/sendCodeForgotPassword.dto';
import { ChangeForgottenPasswordDto } from './dto/changeForgottenPassword.dto';
export declare class AuthController {
    private authService;
    private emailConfirmationService;
    private smsConfirmationService;
    constructor(authService: AuthService, emailConfirmationService: EmailConfirmationService, smsConfirmationService: PhoneConfirmationService);
    email_sign_up(signUpDTO: SignUpDTO): Promise<any>;
    email_login(loginDTO: LoginEmailDTO): Promise<any>;
    refreshToken(data: RefreshTokenDTO): Promise<any>;
    sendOtp(data: SendOtpDTO): Promise<any>;
    confirmOtp(data: ConfirmDTO): Promise<{
        id: any;
        phone_number: string;
        confirmed_at: Date;
        email: string;
        username: string;
    }>;
    sendForgotPasswordCode(data: SendCodeForgottenPassword): Promise<any>;
    confirmForgotPasswordCode(data: ConfirmDTO): Promise<{
        message: string;
        token: any;
    }>;
    changePasswordForgotPassword(data: ChangeForgottenPasswordDto): Promise<any>;
    sendPhoneOtp(data: SendPhoneOtpDTO): Promise<any>;
    confirmPhone(data: ConfirmDTO): Promise<{
        id: any;
        phone_number: string;
        confirmed_at: Date;
        email: string;
        username: string;
    }>;
}
