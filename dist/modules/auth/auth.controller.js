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
exports.AuthController = void 0;
const common_1 = require("@nestjs/common");
const signUp_dto_1 = require("./dto/signUp.dto");
const auth_service_1 = require("./auth.service");
const login_dto_1 = require("./dto/login.dto");
const refreshToken_dto_1 = require("./dto/refreshToken.dto");
const emailconfirmation_service_1 = require("./emailconfirmation.service");
const confirm_dto_1 = require("./dto/confirm.dto");
const sendOtp_dto_1 = require("./dto/sendOtp.dto");
const sendPhoneOtp_dto_1 = require("./dto/sendPhoneOtp.dto");
const phonenumberConfirmation_service_1 = require("./phonenumberConfirmation.service");
const sendCodeForgotPassword_dto_1 = require("./dto/sendCodeForgotPassword.dto");
const changeForgottenPassword_dto_1 = require("./dto/changeForgottenPassword.dto");
let AuthController = class AuthController {
    constructor(authService, emailConfirmationService, smsConfirmationService) {
        this.authService = authService;
        this.emailConfirmationService = emailConfirmationService;
        this.smsConfirmationService = smsConfirmationService;
    }
    async email_sign_up(signUpDTO) {
        return this.authService.emailSignup(signUpDTO);
    }
    async email_login(loginDTO) {
        return this.authService.emailLogin(loginDTO);
    }
    async refreshToken(data) {
        return this.authService.refreshAccessToken(data.refreshToken);
    }
    async sendOtp(data) {
        return this.emailConfirmationService.sendVerification(data.email);
    }
    async confirmOtp(data) {
        return this.emailConfirmationService.confirmUser(data);
    }
    async sendForgotPasswordCode(data) {
        return this.emailConfirmationService.sendForgotPasswordCode(data.email);
    }
    async confirmForgotPasswordCode(data) {
        return this.emailConfirmationService.verifyForgotPasswordCode({
            confirmation_token: data.confirmation_token,
            otp: data.otp,
        });
    }
    async changePasswordForgotPassword(data) {
        return this.authService.changePassword(data.newPassword, data.token);
    }
    async sendPhoneOtp(data) {
        return this.smsConfirmationService.sendVerification(data.phone_number);
    }
    async confirmPhone(data) {
        return this.smsConfirmationService.confirmUser(data);
    }
};
__decorate([
    (0, common_1.Post)('sign_up/email'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [signUp_dto_1.SignUpDTO]),
    __metadata("design:returntype", Promise)
], AuthController.prototype, "email_sign_up", null);
__decorate([
    (0, common_1.Post)('login/email'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [login_dto_1.LoginEmailDTO]),
    __metadata("design:returntype", Promise)
], AuthController.prototype, "email_login", null);
__decorate([
    (0, common_1.Post)('refresh'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [refreshToken_dto_1.RefreshTokenDTO]),
    __metadata("design:returntype", Promise)
], AuthController.prototype, "refreshToken", null);
__decorate([
    (0, common_1.Post)('email/send_otp'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [sendOtp_dto_1.SendOtpDTO]),
    __metadata("design:returntype", Promise)
], AuthController.prototype, "sendOtp", null);
__decorate([
    (0, common_1.Post)('confirm_email'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [confirm_dto_1.ConfirmDTO]),
    __metadata("design:returntype", Promise)
], AuthController.prototype, "confirmOtp", null);
__decorate([
    (0, common_1.Post)('email/forgotten_password/send_code'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [sendCodeForgotPassword_dto_1.SendCodeForgottenPassword]),
    __metadata("design:returntype", Promise)
], AuthController.prototype, "sendForgotPasswordCode", null);
__decorate([
    (0, common_1.Post)('email/confirm_code/forgotten_password'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [confirm_dto_1.ConfirmDTO]),
    __metadata("design:returntype", Promise)
], AuthController.prototype, "confirmForgotPasswordCode", null);
__decorate([
    (0, common_1.Put)('change_password/forgotten_password'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [changeForgottenPassword_dto_1.ChangeForgottenPasswordDto]),
    __metadata("design:returntype", Promise)
], AuthController.prototype, "changePasswordForgotPassword", null);
__decorate([
    (0, common_1.Post)('phone-number/send_otp'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [sendPhoneOtp_dto_1.SendPhoneOtpDTO]),
    __metadata("design:returntype", Promise)
], AuthController.prototype, "sendPhoneOtp", null);
__decorate([
    (0, common_1.Post)('confirm_phone'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [confirm_dto_1.ConfirmDTO]),
    __metadata("design:returntype", Promise)
], AuthController.prototype, "confirmPhone", null);
AuthController = __decorate([
    (0, common_1.Controller)('api/auth'),
    __metadata("design:paramtypes", [auth_service_1.AuthService,
        emailconfirmation_service_1.EmailConfirmationService,
        phonenumberConfirmation_service_1.PhoneConfirmationService])
], AuthController);
exports.AuthController = AuthController;
//# sourceMappingURL=auth.controller.js.map