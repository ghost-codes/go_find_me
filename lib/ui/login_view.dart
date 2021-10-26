import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_android/blocs/authenticationBloc.dart';
import 'package:project_android/components/passwordTextField.dart';
import 'package:project_android/components/text_fields.dart';
import 'package:project_android/locator.dart';
import 'package:project_android/themes/borderRadius.dart';
import 'package:project_android/components/buttons.dart';
import 'package:project_android/themes/dropShadows.dart';
import 'package:project_android/themes/padding.dart';
import 'package:project_android/themes/textStyle.dart';
import 'package:project_android/themes/theme_colors.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with InputDec {
  AuthenticationBloc _authbloc = sl<AuthenticationBloc>();

  GlobalKey _scaffold = GlobalKey();

  @override
  void dispose() {
    _authbloc.isAuthenticating.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      backgroundColor: ThemeColors.white,
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
                Column(
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
                    SizedBox(
                      height: 60,
                    ),
                    StreamBuilder(
                        initialData: false,
                        stream: _authbloc.setGooglePasswordStream,
                        builder: (context, AsyncSnapshot setPass) {
                          return StreamBuilder<bool>(
                              initialData: false,
                              stream: _authbloc.isAuthenticatingStream,
                              builder:
                                  (BuildContext c, AsyncSnapshot snapshot) {
                                return snapshot.data
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: ThemeColors.primary,
                                        ),
                                      )
                                    : Container(
                                        // height: ,
                                        padding: EdgeInsets.all(
                                            2.5 * ThemePadding.padBase),
                                        decoration: BoxDecoration(
                                          color: ThemeColors.white,
                                          borderRadius:
                                              ThemeBorderRadius.bigRadiusAll,
                                          boxShadow: ThemeDropShadow.bigShadow,
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Login",
                                                  style:
                                                      ThemeTexTStyle.headerPrim,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator
                                                        .pushReplacementNamed(
                                                            context, '/signup');
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(7),
                                                    child: Text(
                                                      "Sign Up",
                                                      style: ThemeTexTStyle
                                                          .regular(),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                                height:
                                                    2.5 * ThemePadding.padBase),
                                            setPass.data
                                                ? setPassWord()
                                                : loginForm(context),
                                          ],
                                        ),
                                      );
                              });
                        })
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Form setPassWord() {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: _authbloc.googleUsername,
            decoration: inputDec(hint: "Username"),
          ),
          SizedBox(
            height: 1.5 * ThemePadding.padBase,
          ),
          PasswordTextField(
            controller: _authbloc.googlePassword,
            inputDec: inputDec(hint: "Password"),
          ),
          SizedBox(height: 1.5 * ThemePadding.padBase),
          TextFormField(
            validator: (String? value) {
              return _authbloc.googlePasswordValidate(value);
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: inputDec(hint: "Confirm Password"),
            obscureText: true,
          ),
          SizedBox(height: 50),
          ThemeButton.longButtonPrim(
            text: "Done",
            onpressed: () {
              _authbloc.googleSignUp(_scaffold.currentContext!);
            },
          ),
        ],
      ),
    );
  }

  Form loginForm(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: _authbloc.loginEmail,
            decoration: inputDec(hint: "Username or Email"),
          ),
          SizedBox(height: 2 * ThemePadding.padBase),
          PasswordTextField(
            controller: _authbloc.loginPassworrd,
            inputDec: inputDec(hint: "Password"),
          ),
          SizedBox(height: 50),
          ThemeButton.longButtonPrim(
            text: "Login",
            onpressed: () {
              _authbloc.emailLogin(_scaffold.currentContext!);
            },
          ),
          Divider(
            height: ThemePadding.padBase * 3,
          ),
          Text(
            "or",
            style: ThemeTexTStyle.regular(),
          ),
          SizedBox(
            height: ThemePadding.padBase,
          ),
          ThemeButton.longButtonSec(
              text: "Google",
              onpressed: () async {
                _authbloc.googleSignIn(_scaffold.currentContext!);
              })
        ],
      ),
    );
  }
}

class LoginForm extends StatelessWidget with InputDec {
  // LoginForm({Key? key}) : super(key: key);

  AuthenticationBloc _authbloc = sl<AuthenticationBloc>();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: StreamBuilder<bool>(
          initialData: false,
          stream: _authbloc.setGooglePasswordStream,
          builder: (context, snapshot) {
            return snapshot.data!
                ? Column(
                    children: [
                      TextFormField(
                        controller: _authbloc.googleUsername,
                        decoration: inputDec(hint: "Username"),
                      ),
                      SizedBox(
                        height: 1.5 * ThemePadding.padBase,
                      ),
                      PasswordTextField(
                        controller: _authbloc.googlePassword,
                        inputDec: inputDec(hint: "Password"),
                      ),
                      SizedBox(height: 1.5 * ThemePadding.padBase),
                      TextFormField(
                        validator: (String? value) {
                          return _authbloc.googlePasswordValidate(value);
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: inputDec(hint: "Confirm Password"),
                        obscureText: true,
                      ),
                      SizedBox(height: 50),
                      ThemeButton.longButtonPrim(
                        text: "Done",
                        onpressed: () {
                          _authbloc.googleSignUp(context);
                        },
                      ),
                    ],
                  )
                : Column(
                    children: [
                      TextFormField(
                        controller: _authbloc.loginEmail,
                        decoration: inputDec(hint: "Username or Email"),
                      ),
                      SizedBox(height: 2 * ThemePadding.padBase),
                      PasswordTextField(
                        controller: _authbloc.loginPassworrd,
                        inputDec: inputDec(hint: "Password"),
                      ),
                      SizedBox(height: 50),
                      ThemeButton.longButtonPrim(
                        text: "Login",
                        onpressed: () {
                          _authbloc.emailLogin(context);
                        },
                      ),
                      Divider(
                        height: ThemePadding.padBase * 3,
                      ),
                      Text(
                        "or",
                        style: ThemeTexTStyle.regular(),
                      ),
                      SizedBox(
                        height: ThemePadding.padBase,
                      ),
                      ThemeButton.longButtonSec(
                          text: "Google",
                          onpressed: () async {
                            _authbloc.googleSignIn(context);
                          })
                    ],
                  );
          }),
    );
  }
}
