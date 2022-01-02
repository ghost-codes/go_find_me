import { Controller, Post, Body, Put } from '@nestjs/common';
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

  @Post('email/forgotten_password/send_code')
  async sendForgotPasswordCode(@Body() data: SendCodeForgottenPassword) {
    return this.emailConfirmationService.sendForgotPasswordCode(data.email);
  }

  @Post('email/confirm_code/forgotten_password')
  async confirmForgotPasswordCode(@Body() data: ConfirmDTO) {
    return this.emailConfirmationService.verifyForgotPasswordCode({
      confirmation_token: data.confirmation_token,
      otp: data.otp,
    });
  }

  @Put('change_password/forgotten_password')
  async changePasswordForgotPassword(@Body() data: ChangeForgottenPasswordDto) {
    return this.authService.changePassword(data.newPassword, data.token);
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
