import 'package:flutter/material.dart';
import 'package:project_android/ui/home_view.dart';
import 'package:project_android/ui/login_view.dart';
import 'package:project_android/ui/signup_view.dart';
import 'package:project_android/ui/splash_view.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings setting) {
    switch (setting.name) {
      case "/splash":
        return MaterialPageRoute(builder: (context) => SplashScreen());
      case "/":
        return MaterialPageRoute(builder: (context) => HomeView());
      case "/login":
        return MaterialPageRoute(builder: (context) => Login());
      case "/signup":
        return MaterialPageRoute(builder: (context) => SignUp());

      default:
        return MaterialPageRoute(builder: (context) => Not());
    }
  }
}

class Not extends StatelessWidget {
  const Not({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("Not Found"),
      ),
    );
  }
}
