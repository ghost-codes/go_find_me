import 'package:flutter/material.dart';
import 'package:project_android/modules/auth/authProvider.dart';
import 'package:project_android/themes/theme_colors.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // AuthenticationBloc _authenticationBloc = sl<AuthenticationBloc>();

  @override
  initState() {
    super.initState();
    Provider.of<AuthenticationProvider>(context, listen: false)
        .getStoredUser(context);
    Future.delayed(Duration(milliseconds: 1500), () {});
  }

  // @override
  // void initState() {
  //   Provider.of<AuthenticationProvider>(context, listen: false)
  //       .tokenAuthentication(context);
  //   super.initState();
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(builder: (context, authProv, _) {
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
              // authProv.lastEvent?.state == AuthEventState.loading
              //     ? Center(
              //         child: CircularProgressIndicator(
              //           color: ThemeColors.white,
              //         ),
              //       )
              //     : ThemeButton.ButtonPrim(
              //         text: "Retry",
              //         onpressed: () {
              //           authProv.tokenAuthentication(context);
              //         }),
              SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      );
    });
  }
}
