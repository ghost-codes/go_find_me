import 'package:flutter/material.dart';
import 'package:project_android/themes/textStyle.dart';
import 'package:project_android/themes/theme_colors.dart';

class Dialogs {
  static errorDialog(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: ThemeColors.accent,
        content: Text(
          text,
          style: ThemeTexTStyle.regularwhite,
        ),
      ),
    );
  }
}
