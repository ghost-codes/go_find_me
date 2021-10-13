import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:email_validator/email_validator.dart';
import 'package:project_android/locator.dart';
import 'package:project_android/models/UserModel.dart';
import 'package:project_android/services/api.dart';

class AuthenticationBloc {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  Api _api = sl<Api>();

  UserModel? user;

  GoogleSignInAccount? googleAccount;

  TextEditingController loginPassworrd = TextEditingController();
  TextEditingController loginEmail = TextEditingController();
  TextEditingController googlePassword = TextEditingController();
  TextEditingController googlePasswordConfirm = TextEditingController();
  TextEditingController googleUsername = TextEditingController();

  // StreamController<UserModel?> _userModel = StreamController<UserModel?>();
  // Stream<UserModel?> get userModelStream => _userModel.stream;
  // Sink<UserModel?> get userModelSink => _userModel.sink;

  StreamController<bool> setGooglePassword = StreamController<bool>();
  Stream<bool> get setGooglePasswordStream => setGooglePassword.stream;
  Sink<bool> get setGooglePasswordSink => setGooglePassword.sink;

  emailLogin() async {
    var result = await _api.emailLogin({
      "identity": loginEmail.text,
      "password": loginPassworrd.text,
    }).onError((err) {});
  }

  String? googlePasswordValidate(String? value) {
    print(value);
    if (googlePassword.text == value) {
      return null;
    } else {
      return "Passwords do not match";
    }
  }

  googleSignIn(BuildContext context) async {
    print("ll");
    googleAccount = await _googleSignIn.signIn();
    if (googleAccount != null) {
      UserModel? loginResult =
          await _api.googleSignInAip({"google_id": googleAccount?.id});
      if (loginResult == null) {
        setGooglePasswordSink.add(true);
      } else {
        user = loginResult;
        print("ll");
        Navigator.pushReplacementNamed(context, "/");
      }
    }
  }

  googleSignUp() async {
    if (googleAccount != null) {
      var result = await _api.googleSignUp({
        "photo_url": googleAccount?.photoUrl,
        "google_id": googleAccount?.id,
        "email": googleAccount?.email,
        "password": googlePassword.text,
        "username": googleUsername.text,
      });
    } else {
      googleAccount = await _googleSignIn.signIn();
      var result = await _api.googleSignUp({
        "photo_url": googleAccount?.photoUrl,
        "google_id": googleAccount?.id,
        "email": googleAccount?.email,
        "password": googlePassword.text,
      });
    }
    print("sign up");
  }

  dispose() {
    // _userModel.close();
    setGooglePassword.close();
  }
}
