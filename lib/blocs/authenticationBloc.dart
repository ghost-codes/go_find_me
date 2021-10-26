import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:email_validator/email_validator.dart';
import 'package:project_android/locator.dart';
import 'package:project_android/models/UserModel.dart';
import 'package:project_android/services/api.dart';
import 'package:project_android/themes/textStyle.dart';
import 'package:project_android/themes/theme_colors.dart';

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

  StreamController<bool> setGooglePassword = StreamController<bool>.broadcast();
  Stream<bool> get setGooglePasswordStream => setGooglePassword.stream;
  Sink<bool> get setGooglePasswordSink => setGooglePassword.sink;

  StreamController<bool> isTokenAuthenticating = StreamController<bool>();
  Stream<bool> get isTokenAuthenticatingStream => isTokenAuthenticating.stream;
  Sink<bool> get isTokenAuthenticatingSink => isTokenAuthenticating.sink;

  StreamController<bool> isAuthenticating = StreamController<bool>.broadcast();
  Stream<bool> get isAuthenticatingStream => isAuthenticating.stream;
  Sink<bool> get isAuthenticatingSink => isAuthenticating.sink;

  tokenAuthentication(BuildContext context) async {
    bool isInternetConnected = true;
    isTokenAuthenticatingSink.add(true);
    UserModel? result =
        await _api.tokenAuthentication().onError((error, stackTrace) {
      if (error is DioError &&
          error.type == DioErrorType.other &&
          error.error == SocketException) isInternetConnected = false;
    });
    if (result != null) {
      user = result;
      isTokenAuthenticatingSink.add(false);
      Navigator.pushReplacementNamed(context, "/");
    } else if (isInternetConnected) {
      isTokenAuthenticatingSink.add(false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Check internet Connectivity",
            style: ThemeTexTStyle.regularwhite,
          ),
          backgroundColor: ThemeColors.accent,
        ),
      );
    } else {
      isTokenAuthenticatingSink.add(false);
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  emailLogin(BuildContext context) async {
    isAuthenticatingSink.add(true);
    UserModel? result = await _api.emailLogin({
      "identity": loginEmail.text,
      "password": loginPassworrd.text,
    }).onError((err, stacktrace) {
      isAuthenticatingSink.add(false);
      if (err is DioError) {
        if (err is DioError &&
            err.type == DioErrorType.other &&
            err.error == SocketException) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Check internet Connectivity",
                style: ThemeTexTStyle.regularwhite,
              ),
              backgroundColor: ThemeColors.accent,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(err.response?.data["message"]),
              backgroundColor: ThemeColors.accent,
            ),
          );
        }
      }
    });
    isAuthenticatingSink.add(false);
    if (result != null) {
      user = result;
      Navigator.pushReplacementNamed(context, "/");
    }
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
    googleAccount = await _googleSignIn.signIn();
    if (googleAccount != null) {
      isAuthenticatingSink.add(true);
      UserModel? loginResult = await _api.googleSignInAip(
          {"google_id": googleAccount?.id}).onError((error, stackTrace) {
        isAuthenticatingSink.add(false);
        if (error is DioError &&
            error.type == DioErrorType.other &&
            error.error == SocketException) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Check internet Connectivity",
                style: ThemeTexTStyle.regularwhite,
              ),
              backgroundColor: ThemeColors.accent,
            ),
          );
        }
      });
      isAuthenticatingSink.add(false);
      if (loginResult == null) {
        print(loginResult);
        setGooglePasswordSink.add(true);
      } else {
        user = loginResult;
        Navigator.pushReplacementNamed(context, "/");
      }
    }
  }

  googleSignUp(BuildContext context) async {
    if (googleAccount != null) {
      isAuthenticatingSink.add(true);
      UserModel? result = await _api.googleSignUp({
        "photo_url": googleAccount?.photoUrl,
        "google_id": googleAccount?.id,
        "email": googleAccount?.email,
        "password": googlePassword.text,
        "username": googleUsername.text,
      }).onError((error, stackTrace) {
        isAuthenticatingSink.add(false);
        if (error is DioError &&
            error.type == DioErrorType.other &&
            error.error == SocketException) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Check internet Connectivity",
                style: ThemeTexTStyle.regularwhite,
              ),
              backgroundColor: ThemeColors.accent,
            ),
          );
        }
      });

      isAuthenticatingSink.add(false);
      if (result != null) {
        user = result;
        Navigator.pushReplacementNamed(context, "/");
      }
    } else {
      googleAccount = await _googleSignIn.signIn();
      var result = await _api.googleSignUp({
        "photo_url": googleAccount?.photoUrl,
        "google_id": googleAccount?.id,
        "email": googleAccount?.email,
        "password": googlePassword.text,
      });
    }
  }

  dispose() {
    setGooglePassword.close();
  }
}
