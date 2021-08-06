import 'package:flutter/material.dart';
import 'package:project_android/themes/borderRadius.dart';
import 'package:project_android/themes/dropShadows.dart';
import 'package:project_android/themes/textStyle.dart';
import 'package:project_android/themes/theme_colors.dart';

class ThemeButton {
  static Widget longButtonPrim({String? text, onpressed}) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.primary,
        borderRadius: ThemeBorderRadius.smallRadiusAll,
      ),
      width: double.infinity,
      child: TextButton(
        child: Text(
          text ?? "",
          style: ThemeTexTStyle.buttonTextStylePrime,
        ),
        onPressed: () {
          onpressed();
        },
      ),
    );
  }

  static Widget longButtonSec({String? text, onpressed}) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.white,
        borderRadius: ThemeBorderRadius.smallRadiusAll,
        boxShadow: ThemeDropShadow.smallShadow,
      ),
      width: double.infinity,
      child: TextButton(
        child: Text(
          text ?? "",
          style: ThemeTexTStyle.buttonTextStyleSec,
        ),
        onPressed: () {
          onpressed();
        },
      ),
    );
  }
}
