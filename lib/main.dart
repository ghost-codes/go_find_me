import 'package:flutter/material.dart';
import 'package:project_android/locator.dart';
import 'package:project_android/themes/theme_colors.dart';
import 'package:project_android/ui/splash_view.dart';

void main() {
  setuplocator();
  runApp(GoFindMeApp());
}

class GoFindMeApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: ThemeColors.primary,
      ),
      home: SplashScreen(),
      // initialRoute: "/",
      // routes: {
      //   "/": (context) => SplashScreen(),
      //   "/login": (context) => Login()
      // },
      // onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
