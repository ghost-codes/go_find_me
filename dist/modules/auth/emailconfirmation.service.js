"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.EmailConfirmationService = void 0;
const common_1 = require("@nestjs/common");
const notp = require("notp");
const user_schema_1 = require("../../global/user.schema");
const jwt_1 = require("@nestjs/jwt");
const mongoose_1 = require("mongoose");
const mongoose_2 = require("@nestjs/mongoose");
const mailer_1 = require("@nestjs-modules/mailer");
const uuid_1 = require("uuid");
let EmailConfirmationService = class EmailConfirmationService {
    constructor(jwtService, mailerService, userModel) {
        this.jwtService = jwtService;
        this.mailerService = mailerService;
        this.userModel = userModel;
    }
    async sendVerification(email) {
        const user = await this.userModel.findOne({ email: email });
        if (!user)
            throw new common_1.NotFoundException('User does not exist');
        const confirmation_token = await this.generateConfirmaToken({
            email: email,
        });
        const otp = notp.totp.gen(confirmation_token.confirmation_token, {
            time: 600,
        });
        await this.sendVerificationEmail(user, otp);
        return confirmation_token;
    }
    async sendForgotPasswordCode(email) {
        const user = await this.userModel.findOne({ email: email });
        if (!user)
            throw new common_1.NotFoundException('User does not exist');
        const forgot_password_code = await this.generateConfirmaToken({
            email: email,
        });
        const otp = notp.totp.gen(forgot_password_code.confirmation_token, {
            time: 600,
        });
        await this.sendVerificationEmail(user, otp);
        return forgot_password_code;
    }
    async sendVerificationEmail(user, otp) {
        await this.mailerService
            .sendMail({
            to: user.email,
            subject: 'Verify Email (GoFindMe)',
            text: otp,
            template: 'dist/src/templates/emailconfirmation',
            context: { name: user.username, code: otp },
        })
            .then(() => {
            console.log('');
        })
            .catch((e) => {
            console.log(e);
            throw new common_1.InternalServerErrorException();
        });
    }
    async verifyForgotPasswordCode(forgotPassCode) {
        const payload = await this.verifyConfirmationToken(forgotPassCode.confirmation_token);
        const user = await this.userModel.findOne({ email: payload.email });
        if (!user)
            throw new common_1.NotFoundException('User not found');
        const is_verified = notp.totp.verify(forgotPassCode.otp, forgotPassCode.confirmation_token, { time: 600 });
        if (!is_verified)
            throw new common_1.UnauthorizedException('Wrong passcode');
        user.passHash = (0, uuid_1.v4)();
        const updatedUser = await this.userModel.findByIdAndUpdate(user.id, user);
        if (!updatedUser)
            throw new common_1.InternalServerErrorException('Something went wrong');
        const token = await this.generateConfirmaToken({
            hash: user.passHash,
            email: user.email,
        });
        return { message: 'Correct Passcode', token: token.confirmation_token };
    }
    async confirmUser(confirmEmail) {
        const payload = await this.verifyConfirmationToken(confirmEmail.confirmation_token);
        const user = await this.userModel.findOne({ email: payload.email });
        if (!user)
            throw new common_1.NotFoundException('User not found');
        const is_verified = notp.totp.verify(confirmEmail.otp, confirmEmail.confirmation_token, { time: 600 });
        console.log(is_verified);
        if (!is_verified)
            throw new common_1.UnauthorizedException('Wrong passcode');
        await this.userModel.findByIdAndUpdate(user.id, {
            confirmed_at: new Date(Date.now()),
        });
        const updatedUser = await this.userModel.findById(user.id);
        return {
            id: updatedUser.id,
            phone_number: updatedUser.phone_number,
            confirmed_at: updatedUser.confirmed_at,
            email: updatedUser.email,
            username: updatedUser.username,
        };
    }
    async verifyConfirmationToken(token) {
        try {
            const payload = this.jwtService.verify(token);
            return payload;
        }
        catch (e) {
            throw new common_1.ForbiddenException('Invalid Token');
        }
    }
    async generateConfirmaToken(payload) {
        return {
            confirmation_token: this.jwtService.sign(payload, { expiresIn: '10m' }),
        };
    }
};
EmailConfirmationService = __decorate([
    (0, common_1.Injectable)(),
    __param(2, (0, mongoose_2.InjectModel)(user_schema_1.User.name)),
    __metadata("design:paramtypes", [jwt_1.JwtService,
        mailer_1.MailerService,
        mongoose_1.Model])
], EmailConfirmationService);
exports.EmailConfirmationService = EmailConfirmationService;
//# sourceMappingURL=emailconfirmation.service.js.map