import 'package:flutter/material.dart';
import 'package:project_android/blocs/authenticationBloc.dart';
import 'package:project_android/components/passwordTextField.dart';
import 'package:project_android/components/text_fields.dart';
import 'package:project_android/locator.dart';
import 'package:project_android/modules/auth/authProvider.dart';
import 'package:project_android/themes/borderRadius.dart';
import 'package:project_android/components/buttons.dart';
import 'package:project_android/themes/dropShadows.dart';
import 'package:project_android/themes/padding.dart';
import 'package:project_android/themes/textStyle.dart';
import 'package:project_android/themes/theme_colors.dart';
import 'package:project_android/ui/login_view.dart';
import 'package:provider/provider.dart';

class SignUp extends StatelessWidget with InputDec {
  SignUp({Key? key}) : super(key: key);

  GlobalKey _scaffold = GlobalKey();

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
                      height: 30,
                    ),
                    authProv.lastEvent?.state == AuthEventState.loading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: ThemeColors.primary,
                            ),
                          )
                        : Container(
                            // height: 620,
                            padding: EdgeInsets.all(2.5 * ThemePadding.padBase),
                            decoration: BoxDecoration(
                              color: ThemeColors.white,
                              borderRadius: ThemeBorderRadius.bigRadiusAll,
                              boxShadow: ThemeDropShadow.bigShadow,
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: ThemePadding.padBase * 2,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Sign Up ",
                                      style: ThemeTexTStyle.headerPrim,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Login()));
                                      },
                                      child: Text(
                                        "Login",
                                        style: ThemeTexTStyle.regular(),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 2.5 * ThemePadding.padBase),
                                signup()
                              ],
                            ),
                          )
                  ]),
            ),
          ),
        ),
      );
    });
  }

  Widget signup() {
    return Consumer<AuthenticationProvider>(builder: (context, authProv, _) {
      return Form(
        child: Column(
          children: [
            TextFormField(
              controller: authProv.signUpUsername,
              decoration: inputDec(hint: "Username"),
            ),
            SizedBox(height: 2 * ThemePadding.padBase),
            TextFormField(
              controller: authProv.singupEmail,
              decoration: inputDec(hint: "Email"),
            ),
            SizedBox(height: 2 * ThemePadding.padBase),
            PasswordTextField(
              inputDec: inputDec(hint: "Password"),
              controller: authProv.signUpPassword,
            ),
            SizedBox(height: 2 * ThemePadding.padBase),
            TextFormField(
              autovalidateMode: AutovalidateMode.always,
              validator: (value) {
                return authProv.passwordValidate(
                    value, authProv.signUpPassword);
              },
              decoration: inputDec(hint: "Confirm Password"),
              obscureText: true,
            ),
            SizedBox(height: 50),
            ThemeButton.longButtonPrim(
              text: "Sign Up",
              onpressed: () {
                authProv.emailSignup(_scaffold.currentContext!);
                // Navigator.pushReplacementNamed(_scaffold.currentContext!, '/');
              },
            ),
          ],
        ),
      );
    });
  }
}
