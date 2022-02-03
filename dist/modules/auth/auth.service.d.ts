import { UserReponseModel } from './interfaces/auth.interface';
import { Model } from 'mongoose';
import { User, UserDocument } from 'src/global/user.schema';
import { SignUpDTO } from './dto/signUp.dto';
import { JwtService } from '@nestjs/jwt';
import { UserSession } from './interfaces/userSession.interface';
import { LoginEmailDTO } from './dto/login.dto';
import { EmailConfirmationService } from './emailconfirmation.service';
export declare class AuthService {
    private readonly userModel;
    private jwtService;
    private emailConfirmationService;
    constructor(userModel: Model<UserDocument>, jwtService: JwtService, emailConfirmationService: EmailConfirmationService);
    validateUser(username: string, pass: string): Promise<UserReponseModel | null>;
    validatePassHash(passHash: string, username: string): Promise<boolean>;
    emailSignup(signUpDto: SignUpDTO): Promise<any>;
    changePassword(newPassword: string, token: string): Promise<any>;
    emailLogin(loginDTO: LoginEmailDTO): Promise<any>;
    refreshAccessToken(refreshToken: string): Promise<UserSession>;
    validateToken(token: string): Promise<any>;
    bcryptCompare(passwordString: string, hash: string): Promise<boolean>;
    generateAccessToken(user: any): Promise<{
        access_token: string;
    }>;
    generateRefreshToken(user: User): Promise<{
        refresh_token: string;
    }>;
}
