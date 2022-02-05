"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AuthModule = void 0;
const common_1 = require("@nestjs/common");
const mongoose_1 = require("@nestjs/mongoose");
const passport_1 = require("@nestjs/passport");
const user_schema_1 = require("../../global/user.schema");
const auth_controller_1 = require("./auth.controller");
const auth_service_1 = require("./auth.service");
const local_strategy_1 = require("./strategies/local.strategy");
const jwt_1 = require("@nestjs/jwt");
const constant_1 = require("./constant");
const bcrypt = require("bcrypt");
const jwt_strategies_1 = require("./strategies/jwt.strategies");
const emailconfirmation_service_1 = require("./emailconfirmation.service");
const phonenumberConfirmation_service_1 = require("./phonenumberConfirmation.service");
const sms_service_1 = require("../sms/sms.service");
const sms_module_1 = require("../sms/sms.module");
const user_service_1 = require("./user.service");
let AuthModule = class AuthModule {
};
AuthModule = __decorate([
    (0, common_1.Module)({
        imports: [
            sms_service_1.SmsService,
            mongoose_1.MongooseModule.forFeatureAsync([
                {
                    name: user_schema_1.User.name,
                    useFactory: () => {
                        const schema = user_schema_1.UserSchema;
                        schema.pre('save', function (next) {
                            const user = this;
                            bcrypt.hash(user.password, 10).then((value) => {
                                user.password = value;
                                next();
                            });
                        });
                        return schema;
                    },
                },
            ]),
            passport_1.PassportModule.register({ defaultStrategy: 'jwt' }),
            jwt_1.JwtModule.register({
                secret: constant_1.jwtConstants.secret,
                signOptions: { expiresIn: '2h' },
            }),
            sms_module_1.SmsModule,
        ],
        controllers: [auth_controller_1.AuthController],
        providers: [
            auth_service_1.AuthService,
            local_strategy_1.LocalStrategy,
            jwt_strategies_1.JwtStrategy,
            emailconfirmation_service_1.EmailConfirmationService,
            phonenumberConfirmation_service_1.PhoneConfirmationService,
            user_service_1.UserService,
        ],
        exports: [user_service_1.UserService],
    })
], AuthModule);
exports.AuthModule = AuthModule;
//# sourceMappingURL=auth.module.js.map