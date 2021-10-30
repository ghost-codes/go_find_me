import 'package:flutter/material.dart';
import 'package:project_android/blocs/authenticationBloc.dart';
import 'package:project_android/locator.dart';
import 'package:project_android/models/UserModel.dart';
import 'package:project_android/ui/home_view.dart';
import 'package:project_android/ui/login_view.dart';

class RootView extends StatelessWidget {
  RootView({Key? key}) : super(key: key);
  AuthenticationBloc _authBloc = sl<AuthenticationBloc>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel?>(
        stream: _authBloc.userModelStream,
        builder: (context, snapshot) {
          return snapshot.data == null ? Login() : HomeView();
        });
  }
}
