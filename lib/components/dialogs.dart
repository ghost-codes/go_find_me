import 'package:flutter/material.dart';
import 'package:project_android/themes/textStyle.dart';

class Dialogs {
  static errorDialog(context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: ThemeTexTStyle.regularwhite,
        ),
      ),
    );
  }
}
