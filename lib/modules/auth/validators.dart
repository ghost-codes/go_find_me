import 'package:flutter/material.dart';

class AuthValidators {
  static String? passwordValidate(String? value, TextEditingController pass) {
    print(value);
    if (pass.text == value) {
      return null;
    } else {
      return "Passwords do not match";
    }
  }

  static String? isEmptyValidator(String val) {
    if (val.trim().length == 0) return "Input required";
    return null;
  }
}
