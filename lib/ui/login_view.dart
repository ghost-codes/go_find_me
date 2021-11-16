import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:project_android/components/passwordTextField.dart';
import 'package:project_android/components/text_fields.dart';
import 'package:project_android/modules/auth/authProvider.dart';
import 'package:project_android/themes/borderRadius.dart';
import 'package:project_android/components/buttons.dart';
import 'package:project_android/themes/dropShadows.dart';
import 'package:project_android/themes/padding.dart';
import 'package:project_android/themes/textStyle.dart';
import 'package:project_android/themes/theme_colors.dart';
import 'package:project_android/ui/signup_view.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with InputDec {
  GlobalKey _scaffold = GlobalKey();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(builder: (context, authProv, _) {
      return Scaffold(
        key: _scaffold,
        backgroundColor: ThemeColors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              color: ThemeColors.white,
              padding: EdgeInsets.all(2 * ThemePadding.padBase),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: ThemeColors.primary,
                            radius: 20,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "GoFindMe",
                            style: TextStyle(
                                color: ThemeColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 30),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      authProv.lastEvent?.state == AuthEventState.loading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: ThemeColors.primary,
                              ),
                            )
                          : Container(
                              // height: ,
                              padding: EdgeInsets.all(2 * ThemePadding.padBase),
                              decoration: BoxDecoration(
                                color: ThemeColors.white,
                                borderRadius: ThemeBorderRadius.bigRadiusAll,
                                boxShadow: ThemeDropShadow.bigShadow,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Login",
                                        style: ThemeTexTStyle.headerPrim,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SignUp()));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(7),
                                          child: Text(
                                            "Sign Up",
                                            style: ThemeTexTStyle.regular(),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 2.5 * ThemePadding.padBase),
                                  authProv.isPhoneLogin
                                      ? loginPhoneForm(context)
                                      : loginEmailForm(context),
                                ],
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget loginPhoneForm(BuildContext context) {
    return Consumer<AuthenticationProvider>(builder: (context, authProv, _) {
      return Form(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: ThemeColors.primary.withOpacity(0.07),
                borderRadius: ThemeBorderRadius.smallRadiusAll,
              ),
              child: InternationalPhoneNumberInput(
                  inputDecoration: inputDec(hint: "Phone number"),
                  ignoreBlank: true,
                  spaceBetweenSelectorAndTextField: 2,
                  keyboardType: TextInputType.number,
                  selectorConfig: SelectorConfig(
                      leadingPadding: 0,
                      showFlags: false,
                      selectorType: PhoneInputSelectorType.DIALOG),
                  maxLength: 11,
                  onInputChanged: authProv.setLoginPhoneNumber),
            ),
            SizedBox(height: 2 * ThemePadding.padBase),
            PasswordTextField(
              controller: authProv.loginPassworrd,
              inputDec: inputDec(hint: "Password"),
            ),
            SizedBox(height: 50),
            ThemeButton.longButtonPrim(
              text: "Login",
              onpressed: () {
                authProv.phoneLogin(_scaffold.currentContext!);
              },
            ),
            Divider(
              height: ThemePadding.padBase * 3,
            ),
            ThemeButton.ButtonSec(
                text: "Login with email",
                width: double.infinity,
                onpressed: authProv.setIsPhoneLogin)
          ],
        ),
      );
    });
  }

  Widget loginEmailForm(BuildContext context) {
    return Consumer<AuthenticationProvider>(builder: (context, authProv, _) {
      return Form(
        key: authProv.loginEmailFormKey,
        child: Column(
          children: [
            TextFormField(
              validator: (val) {
                return authProv.isEmptyValidator(val!);
              },
              controller: authProv.loginEmail,
              decoration: inputDec(hint: "Username or Email"),
            ),
            SizedBox(height: 2 * ThemePadding.padBase),
            PasswordTextField(
              validator: (val) {
                return authProv.isEmptyValidator(val!);
              },
              controller: authProv.loginPassworrd,
              inputDec: inputDec(hint: "Password"),
            ),
            SizedBox(height: 50),
            ThemeButton.longButtonPrim(
              text: "Login",
              onpressed: () {
                authProv.emailLogin(_scaffold.currentContext!);
              },
            ),
            Divider(
              height: ThemePadding.padBase * 3,
            ),
            ThemeButton.ButtonSec(
                text: "Login with phone",
                width: double.infinity,
                onpressed: authProv.setIsPhoneLogin)
          ],
        ),
      );
    });
  }
}
