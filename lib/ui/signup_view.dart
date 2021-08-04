import 'package:flutter/material.dart';
import 'package:project_android/components/text_fields.dart';
import 'package:project_android/themes/borderRadius.dart';
import 'package:project_android/themes/buttons.dart';
import 'package:project_android/themes/dropShadows.dart';
import 'package:project_android/themes/padding.dart';
import 'package:project_android/themes/textStyle.dart';
import 'package:project_android/themes/theme_colors.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

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
                  radius: 20,
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 620,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Sign Up ",
                            style: ThemeTexTStyle.headerPrim,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            child: Text(
                              "Login",
                              style: ThemeTexTStyle.regular,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 2.5 * ThemePadding.padBase),
                      SignUpForm(),
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

class SignUpForm extends InputDec {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            decoration: inputDec(hint: "Name"),
          ),
          SizedBox(height: 2 * ThemePadding.padBase),
          TextFormField(
            decoration: inputDec(hint: "Email"),
          ),
          SizedBox(height: 2 * ThemePadding.padBase),
          TextFormField(
            decoration: inputDec(hint: "Password"),
            obscureText: true,
          ),
          SizedBox(height: 2 * ThemePadding.padBase),
          TextFormField(
            decoration: inputDec(hint: "Confirm Password"),
            obscureText: true,
          ),
          SizedBox(height: 50),
          ThemeButton.longButtonPrim(
            text: "Sign Up",
            onpressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          Divider(
            height: ThemePadding.padBase * 3,
          ),
          Text(
            "or",
            style: ThemeTexTStyle.regular,
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
