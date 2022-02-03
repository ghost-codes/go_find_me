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
exports.PhoneConfirmationService = void 0;
const common_1 = require("@nestjs/common");
const sms_service_1 = require("../sms/sms.service");
const jwt_1 = require("@nestjs/jwt");
const mongoose_1 = require("mongoose");
const user_schema_1 = require("../../global/user.schema");
const mongoose_2 = require("@nestjs/mongoose");
const notp = require("notp");
let PhoneConfirmationService = class PhoneConfirmationService {
    constructor(smsService, jwtService, userModel) {
        this.smsService = smsService;
        this.jwtService = jwtService;
        this.userModel = userModel;
    }
    async sendVerification(phone_number) {
        const user = await this.userModel.findOne({
            phone_number: phone_number,
        });
        const confirmation_token = await this.generateConfirmaToken({
            phone_number: phone_number,
        });
        const otp = notp.totp.gen(confirmation_token.confirmation_token, {
            time: 600,
        });
        await this.smsService.intiatePhoneNumberVerification(phone_number, `Here is your verification code ${otp}`);
        return confirmation_token;
    }
    async confirmUser(confirmEmail) {
        const payload = await this.verifyConfirmationToken(confirmEmail.confirmation_token);
        const user = await this.userModel.findOne({ phone_number: payload });
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
            return payload.phone_number;
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
PhoneConfirmationService = __decorate([
    (0, common_1.Injectable)(),
    __param(2, (0, mongoose_2.InjectModel)(user_schema_1.User.name)),
    __metadata("design:paramtypes", [sms_service_1.SmsService,
        jwt_1.JwtService,
        mongoose_1.Model])
], PhoneConfirmationService);
exports.PhoneConfirmationService = PhoneConfirmationService;
//# sourceMappingURL=phonenumberConfirmation.service.js.map