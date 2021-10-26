import 'package:flutter/material.dart';
import 'package:project_android/themes/borderRadius.dart';
import 'package:project_android/themes/theme_colors.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({Key? key, this.controller, this.inputDec})
      : super(key: key);
  final TextEditingController? controller;
  final InputDecoration? inputDec;

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: widget.controller,
              decoration: widget.inputDec,
              obscureText: obscureText,
            ),
          ),
          Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
                color: ThemeColors.primary.withOpacity(0.1),
                borderRadius: ThemeBorderRadius.smallRadiusAll),
            child: IconButton(
              onPressed: () {
                setState(() {
                  obscureText = !obscureText;
                });
              },
              icon: Icon(
                !obscureText ? Icons.visibility : Icons.visibility_off,
                color: ThemeColors.grey,
              ),
            ),
          )
        ],
      ),
    );
  }
}
