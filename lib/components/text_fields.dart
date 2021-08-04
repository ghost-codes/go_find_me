import 'package:flutter/material.dart';
import 'package:project_android/themes/borderRadius.dart';
import 'package:project_android/themes/textStyle.dart';
import 'package:project_android/themes/theme_colors.dart';

class InputDec extends StatelessWidget {
  const InputDec({Key? key}) : super(key: key);

  InputDecoration inputDec({
    String? hint,
  }) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: ThemeBorderRadius.smallRadiusAll,
      ),
      filled: true,
      fillColor: ThemeColors.primary.withOpacity(0.07),
      hintText: hint,
      hintStyle: ThemeTexTStyle.textField,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
