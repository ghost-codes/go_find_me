import 'package:flutter/material.dart';
import 'package:project_android/themes/theme_colors.dart';

class ThemeTexTStyle {
  static const TextStyle textField = TextStyle(
    color: ThemeColors.grey,
    fontSize: 13,
    fontFamily: "Montserrat",
  );

  static const TextStyle buttonTextStylePrime = TextStyle(
    fontSize: 15,
    color: ThemeColors.white,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w700,
  );

  static const TextStyle buttonTextStyleSec = TextStyle(
    fontSize: 15,
    color: ThemeColors.grey,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w700,
  );

  static const TextStyle titleTextStyleBlack = TextStyle(
    fontSize: 15,
    color: ThemeColors.black,
    fontFamily: "Montserrat",
    fontWeight: FontWeight.w500,
  );

  static const TextStyle headerPrim = TextStyle(
    fontFamily: "Montserrat",
    color: ThemeColors.primary,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle regular = TextStyle(
    fontFamily: "Montserrat",
    color: ThemeColors.black,
    fontSize: 13,
  );
  static const TextStyle regularPrim = TextStyle(
    fontFamily: "Montserrat",
    color: ThemeColors.primary,
    fontSize: 13,
  );

  static const TextStyle regularwhite = TextStyle(
    fontFamily: "Montserrat",
    color: ThemeColors.white,
    fontSize: 13,
  );
}
