import 'package:flutter/material.dart';
import 'package:project_android/components/buttons.dart';
import 'package:project_android/components/text_fields.dart';
import 'package:project_android/themes/padding.dart';
import 'package:project_android/themes/textStyle.dart';
import 'package:project_android/themes/theme_colors.dart';
import 'package:pinput/pin_put/pin_put.dart';

class VerifyAccount extends StatelessWidget with InputDec {
  VerifyAccount({Key? key}) : super(key: key);
  final TextEditingController _pinPutEmailController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          padding: EdgeInsets.all(ThemePadding.padBase * 3),
          color: ThemeColors.white,
          child: SingleChildScrollView(
              child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Text(
                "Verify Account",
                style: ThemeTexTStyle.headerPrim,
              ),
              SizedBox(
                height: 10,
              ),
              verificationTypeSelect(),
            ],
          )),
        ),
      ),
    );
  }

  Widget verificationTypeSelect() {
    return Column(
      children: [
        Text(
          "Selecte method of verification",
          style: ThemeTexTStyle.regularPrim,
        ),
        SizedBox(
          height: 30,
        ),
        ThemeButton.ButtonPrim(text: "Verify Using Email"),
        SizedBox(
          height: 10,
        ),
        ThemeButton.ButtonSec(
            width: double.infinity, text: "Verify using phone")
      ],
    );
  }

  Widget emailVerificationInput() {
    return Column(
      children: [
        Text(
          "Verification code sent to email",
          style: ThemeTexTStyle.regularPrim,
        ),
        SizedBox(
          height: 30,
        ),
        PinPut(
          fieldsCount: 6,
          selectedFieldDecoration: BoxDecoration(
            color: ThemeColors.white,
            border: Border.all(color: ThemeColors.primary),
            borderRadius: BorderRadius.circular(5),
          ),
          followingFieldDecoration: BoxDecoration(
            color: ThemeColors.primary.withOpacity(0.17),
            borderRadius: BorderRadius.circular(5),
          ),
          // onSubmit: (String pin) => _showSnackBar(pin, context),
          focusNode: _pinPutFocusNode,
          keyboardType: TextInputType.numberWithOptions(),
          controller: _pinPutEmailController,
          submittedFieldDecoration: BoxDecoration(
            color: ThemeColors.primary.withOpacity(0.17),
            border: Border.all(color: ThemeColors.primary),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ],
    );
  }
}
