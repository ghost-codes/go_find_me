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
exports.AuthService = void 0;
const common_1 = require("@nestjs/common");
const mongoose_1 = require("mongoose");
const mongoose_2 = require("@nestjs/mongoose");
const user_schema_1 = require("../../global/user.schema");
const jwt_1 = require("@nestjs/jwt");
const bcrypt = require("bcrypt");
const uuid_1 = require("uuid");
const emailconfirmation_service_1 = require("./emailconfirmation.service");
let AuthService = class AuthService {
    constructor(userModel, jwtService, emailConfirmationService) {
        this.userModel = userModel;
        this.jwtService = jwtService;
        this.emailConfirmationService = emailConfirmationService;
    }
    async validateUser(username, pass) {
        const user = await this.userModel.findOne({ username: username });
        if (user && user.password === pass) {
            const userResponseModel = user;
            return userResponseModel;
        }
        return null;
    }
    async validatePassHash(passHash, username) {
        const user = await this.userModel.findOne({ username: username });
        return passHash === user.passHash;
    }
    async emailSignup(signUpDto) {
        const newUser = new this.userModel(Object.assign(Object.assign({}, signUpDto), { passHash: (0, uuid_1.v4)() }));
        const savedUser = await newUser.save();
        const userResponse = savedUser;
        const access_token = await this.generateAccessToken(savedUser);
        const refresh_token = await this.generateRefreshToken(savedUser);
        const response = {
            user: {
                username: userResponse.username,
                email: userResponse.email,
                id: userResponse.id,
                phone_number: userResponse.phone_number,
                confirmed_at: userResponse.confirmed_at,
                bookmarked_posts: savedUser.bookmarked_posts,
            },
            accessToken: access_token.access_token,
            refreshToken: refresh_token.refresh_token,
        };
        console.log(response);
        return response;
    }
    async changePassword(newPassword, token) {
        const payload = await this.emailConfirmationService.verifyConfirmationToken(token);
        const user = await this.userModel.findOne({ email: payload.email });
        if (payload.hash !== user.passHash)
            throw new common_1.UnauthorizedException('Please provide correct parameters');
        await bcrypt.hash(newPassword, 10).then((value) => {
            user.password = value;
        });
        const updatedUser = await this.userModel.findByIdAndUpdate(user.id, user);
        if (!updatedUser)
            throw new common_1.InternalServerErrorException('Something went wrong');
        return { message: 'Password change was successful' };
    }
    async emailLogin(loginDTO) {
        const user = await this.userModel.findOne({
            $or: [
                { username: loginDTO.identity },
                { email: loginDTO.identity },
                { phone_number: loginDTO.identity },
            ],
        });
        if (!user)
            throw new common_1.UnauthorizedException('Invalid email or password');
        if (!(await this.bcryptCompare(loginDTO.password, user.password)))
            throw new common_1.UnauthorizedException('Invalid email or password');
        const accessToken = await this.generateAccessToken(user);
        const refreshToken = await this.generateRefreshToken(user);
        const response = {
            user: {
                username: user.username,
                email: user.email,
                id: user.id,
                phone_number: user.phone_number,
                confirmed_at: user.confirmed_at,
            },
            accessToken: accessToken.access_token,
            refreshToken: refreshToken.refresh_token,
        };
        console.log(response);
        return response;
    }
    async refreshAccessToken(refreshToken) {
        const payload = await this.validateToken(refreshToken);
        if (!payload)
            throw new common_1.UnauthorizedException('Unathorized credentials');
        const user = await this.userModel.findOne({
            username: payload.username,
        });
        if (!user)
            throw new common_1.UnauthorizedException('Unauthorized credentials');
        if (user.passHash != payload.passHash)
            throw new common_1.UnauthorizedException('Password has been changed');
        const accessToken = await this.generateAccessToken(payload);
        const userSession = {
            accessToken: accessToken.access_token,
            refreshToken: refreshToken,
        };
        return userSession;
    }
    async validateToken(token) {
        try {
            const result = this.jwtService.verifyAsync(token);
            return result;
        }
        catch (e) { }
        return null;
    }
    async bcryptCompare(passwordString, hash) {
        return await bcrypt.compare(passwordString, hash);
    }
    async generateAccessToken(user) {
        const payload = {
            username: user.username,
            sub: user.id,
            passHash: user.passHash,
        };
        return {
            access_token: this.jwtService.sign(payload),
        };
    }
    async generateRefreshToken(user) {
        const payload = {
            username: user.username,
            sub: user.id,
            passHash: user.passHash,
        };
        return {
            refresh_token: this.jwtService.sign(payload, { expiresIn: '500d' }),
        };
    }
};
AuthService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, mongoose_2.InjectModel)(user_schema_1.User.name)),
    __metadata("design:paramtypes", [mongoose_1.Model,
        jwt_1.JwtService,
        emailconfirmation_service_1.EmailConfirmationService])
], AuthService);
exports.AuthService = AuthService;
//# sourceMappingURL=auth.service.js.map