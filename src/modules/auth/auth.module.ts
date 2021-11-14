import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { PassportModule } from '@nestjs/passport';
import { User, UserSchema } from 'src/global/user.schema';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { LocalStrategy } from './strategies/local.strategy';
import { JwtModule } from '@nestjs/jwt';
import { jwtConstants } from './constant';
import * as bcrypt from 'bcrypt';
import { JwtStrategy } from './strategies/jwt.strategies';
import { EmailConfirmationService } from './emailconfirmation.service';
import { PhoneConfirmationService } from './phonenumberConfirmation.service';
import { SmsService } from '../sms/sms.service';
import { SmsModule } from '../sms/sms.module';

@Module({
  imports: [
    SmsService,
    MongooseModule.forFeatureAsync([
      {
        name: User.name,
        useFactory: () => {
          const schema = UserSchema;
          schema.pre<User>('save', function (next) {
            const user: User = this;
            bcrypt.hash(user.password, 10).then((value) => {
              user.password = value;
              next();
            });
          });

          return schema;
        },
      },
    ]),
    PassportModule.register({ defaultStrategy: 'jwt' }),
    JwtModule.register({
      secret: jwtConstants.secret,
      signOptions: { expiresIn: '2h' },
    }),
    SmsModule,
  ],
  controllers: [AuthController],
  providers: [
    AuthService,
    LocalStrategy,
    JwtStrategy,
    EmailConfirmationService,
    PhoneConfirmationService,
  ],
})
export class AuthModule {}
