import 'package:flutter/material.dart';
import 'package:project_android/components/text_fields.dart';
import 'package:project_android/themes/borderRadius.dart';
import 'package:project_android/components/buttons.dart';
import 'package:project_android/themes/dropShadows.dart';
import 'package:project_android/themes/padding.dart';
import 'package:project_android/themes/textStyle.dart';
import 'package:project_android/themes/theme_colors.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                CircleAvatar(
                  backgroundColor: ThemeColors.primary,
                  radius: 80,
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 500,
                  padding: EdgeInsets.all(2.5 * ThemePadding.padBase),
                  decoration: BoxDecoration(
                    color: ThemeColors.white,
                    borderRadius: ThemeBorderRadius.bigRadiusAll,
                    boxShadow: ThemeDropShadow.bigShadow,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: ThemePadding.padBase * 3,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Login",
                            style: ThemeTexTStyle.headerPrim,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, '/signup');
                            },
                            child: Text(
                              "Sign Up",
                              style: ThemeTexTStyle.regular(),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 2.5 * ThemePadding.padBase),
                      LoginForm(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends InputDec {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            decoration: inputDec(hint: "Username or Email"),
          ),
          SizedBox(height: 2 * ThemePadding.padBase),
          TextFormField(
            decoration: inputDec(hint: "Password"),
            obscureText: true,
          ),
          SizedBox(height: 50),
          ThemeButton.longButtonPrim(
            text: "Login",
            onpressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          Divider(
            height: ThemePadding.padBase * 3,
          ),
          Text(
            "or",
            style: ThemeTexTStyle.regular(),
          ),
          SizedBox(
            height: ThemePadding.padBase,
          ),
          ThemeButton.longButtonSec(
              text: "Google",
              onpressed: () {
                Navigator.pushReplacementNamed(context, '/');
              })
        ],
      ),
    );
  }
}
