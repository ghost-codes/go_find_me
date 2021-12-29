import { ExtractJwt, Strategy } from 'passport-jwt';
import { PassportStrategy } from '@nestjs/passport';
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { AuthService } from '../auth.service';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(private authService: AuthService) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: 'AccessTokenForGoFindMeServerHope',
    });
  }

  async validate(payload: any) {
    const isPassNotChanged = await this.authService.validatePassHash(
      payload.passHash,
      payload.username,
    );
    if (!isPassNotChanged)
      throw new UnauthorizedException('Password has been changed please login');
    return { userId: payload.sub, username: payload.username };
  }
}
