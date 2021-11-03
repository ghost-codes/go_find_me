import { Controller, Post, Body } from '@nestjs/common';
import { SignUpDTO } from './dto/signUp.dto';
import { AuthService } from './auth.service';
import { LoginEmailDTO } from './dto/login.dto';
import { RefreshTokenDTO } from './dto/refreshToken.dto';

@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

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
  async refreshToken(@Body() data: RefreshTokenDTO) {
    return this.authService.refreshAccessToken(data.refreshToken);
  }
}
