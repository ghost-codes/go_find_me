import 'package:flutter/material.dart';
import 'package:project_android/components/buttons.dart';
import 'package:project_android/themes/padding.dart';
import 'package:project_android/themes/theme_colors.dart';
import 'package:project_android/ui/login_view.dart';
import 'package:project_android/ui/signup_email_view.dart';

class BaseAuthView extends StatelessWidget {
  const BaseAuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(ThemePadding.padBase * 2),
          color: ThemeColors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              SizedBox(height: ThemePadding.padBase * 6),
              ThemeButton.longButtonPrim(
                text: "Login",
                onpressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Login()));
                },
              ),
              Divider(
                height: ThemePadding.padBase * 3,
              ),
              ThemeButton.longButtonPrim(
                text: "Signup with Email",
                onpressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Login()));
                },
              ),
              SizedBox(height: ThemePadding.padBase * 2),
              ThemeButton.ButtonSec(
                  text: "Signup with phone number",
                  width: double.infinity,
                  onpressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SignUpEmail()));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
