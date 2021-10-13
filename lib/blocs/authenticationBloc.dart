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

  GoogleSignInAccount? googleAccount;

  TextEditingController loginPassworrd = TextEditingController();
  TextEditingController loginEmail = TextEditingController();
  TextEditingController googlePassword = TextEditingController();
  TextEditingController googlePasswordConfirm = TextEditingController();

  StreamController<UserModel?> _userModel = StreamController<UserModel?>();
  Stream<UserModel?> get userModelStream => _userModel.stream;
  Sink<UserModel?> get userModelSink => _userModel.sink;

  StreamController<bool> setGooglePassword = StreamController<bool>();
  Stream<bool> get setGooglePasswordStream => setGooglePassword.stream;
  Sink<bool> get setGooglePasswordSink => setGooglePassword.sink;

  emailLogin() async {
    var result = await _api.emailLogin({
      "identity": loginEmail.text,
      "password": loginPassworrd.text,
    });
    print(result);
  }

  String? googlePasswordValidate(String? value) {
    print(value);
    if (googlePassword.text == value) {
      return null;
    } else {
      return "Passwords do not match";
    }
  }

  googleSignIn() async {
    googleAccount = await _googleSignIn.signIn();
    if (googleAccount != null) {
      UserModel? loginResult =
          await _api.googleSignInAip({"google_id": googleAccount?.id});
      if (loginResult == null) {
        userModelSink.add(loginResult);
        setGooglePasswordSink.add(true);
      } else {
        print("login");
        print(json.encode(loginResult));
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
}
