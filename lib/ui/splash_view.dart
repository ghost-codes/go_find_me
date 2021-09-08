import 'package:flutter/material.dart';
import 'package:project_android/themes/theme_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 1500), () {
      Navigator.pushReplacementNamed(context, "/login");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeColors.primary,
      child: Center(
        child: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
