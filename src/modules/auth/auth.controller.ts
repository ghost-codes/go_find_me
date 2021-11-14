import { Controller, Post, Body } from '@nestjs/common';
import { SignUpDTO } from './dto/signUp.dto';
import { AuthService } from './auth.service';
import { LoginEmailDTO } from './dto/login.dto';
import { RefreshTokenDTO } from './dto/refreshToken.dto';
import { EmailConfirmationService } from './emailconfirmation.service';
import { ConfirmDTO } from './dto/confirm.dto';
import { SendOtpDTO } from './dto/sendOtp.dto';
import { SendPhoneOtpDTO } from './dto/sendPhoneOtp.dto';
import { PhoneConfirmationService } from './phonenumberConfirmation.service';

@Controller('api/auth')
export class AuthController {
  constructor(
    private authService: AuthService,
    private emailConfirmationService: EmailConfirmationService,
    private smsConfirmationService: PhoneConfirmationService,
  ) {}

  // @UseGuards(LocalAuthGuard)
  @Post('sign_up/email')
  async email_sign_up(@Body() signUpDTO: SignUpDTO): Promise<any> {
    return this.authService.emailSignup(signUpDTO);
  }

  @Post('login/email')
  async email_login(@Body() loginDTO: LoginEmailDTO) {
    return this.authService.emailLogin(loginDTO);
  }

  @Post('refresh')
  async refreshToken(@Body() data: RefreshTokenDTO): Promise<any> {
    return this.authService.refreshAccessToken(data.refreshToken);
  }

  @Post('email/send_otp')
  async sendOtp(@Body() data: SendOtpDTO) {
    return this.emailConfirmationService.sendVerification(data.email);
  }
  @Post('confirm_email')
  async confirmOtp(@Body() data: ConfirmDTO) {
    return this.emailConfirmationService.confirmUser(data);
  }

  @Post('phone-number/send_otp')
  async sendPhoneOtp(@Body() data: SendPhoneOtpDTO) {
    return this.smsConfirmationService.sendVerification(data.phone_number);
  }

  @Post('confirm_phone')
  async confirmPhone(@Body() data: ConfirmDTO) {
    return this.smsConfirmationService.confirmUser(data);
  }
}
