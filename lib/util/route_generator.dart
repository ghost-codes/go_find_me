import 'package:flutter/material.dart';
import 'package:project_android/ui/home_view.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings setting) {
    return MaterialPageRoute(builder: (context) => HomeView());
  }
}
