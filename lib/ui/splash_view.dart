import 'package:flutter/material.dart';
import 'package:project_android/blocs/authenticationBloc.dart';
import 'package:project_android/components/buttons.dart';
import 'package:project_android/locator.dart';
import 'package:project_android/themes/theme_colors.dart';
import 'package:project_android/ui/login_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthenticationBloc _authenticationBloc = sl<AuthenticationBloc>();

  // @override
  // void initState() {
  //   super.initState();
  //   print("object");

  //   Future.delayed(Duration(milliseconds: 1500), () {
  //     Navigator.pushReplacement(
  //         context, MaterialPageRoute(builder: (context) => Login()));
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _authenticationBloc.tokenAuthentication(context);
  }

  @override
  void dispose() {
    _authenticationBloc.isTokenAuthenticating.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ThemeColors.primary,
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "GoFindMe",
                      style: TextStyle(
                          color: ThemeColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    )
                  ],
                ),
              ),
            ),
            StreamBuilder<bool>(
                initialData: false,
                stream: _authenticationBloc.isTokenAuthenticatingStream,
                builder: (context, snapshot) {
                  return snapshot.data != null && snapshot.data!
                      ? Center(
                          child: CircularProgressIndicator(
                            color: ThemeColors.white,
                          ),
                        )
                      : ThemeButton.ButtonPrim(
                          text: "Retry",
                          onpressed: () {
                            _authenticationBloc.tokenAuthentication(context);
                          });
                }),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}
