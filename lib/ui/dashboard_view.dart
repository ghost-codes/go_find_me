import 'package:flutter/material.dart';
import 'package:project_android/blocs/home_bloc.dart';

class DashboardView extends StatelessWidget {
  DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Text("DashBoard"),
      ),
    );
  }
}
