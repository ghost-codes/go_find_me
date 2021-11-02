import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  UseGuards,
} from '@nestjs/common';
import { SignUpDTO } from './dto/signUp.dto';
import { AuthService } from './auth.service';

@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  // @UseGuards(LocalAuthGuard)
  @Post('sign_up/email')
  async email_sign_up(@Body() signUpDTO: SignUpDTO): Promise<any> {
    return this.authService.emailSignup(signUpDTO);
  }
}
