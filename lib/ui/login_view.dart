import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
                              padding:
                                  EdgeInsets.all(2.5 * ThemePadding.padBase),
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
                                  loginForm(context),
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

  Widget loginForm(BuildContext context) {
    return Consumer<AuthenticationProvider>(builder: (context, authProv, _) {
      return Form(
        child: Column(
          children: [
            TextFormField(
              controller: authProv.loginEmail,
              decoration: inputDec(hint: "Username or Email"),
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
                authProv.emailLogin(_scaffold.currentContext!);
              },
            ),
            Divider(
              height: ThemePadding.padBase * 3,
            ),
          ],
        ),
      );
    });
  }
}
