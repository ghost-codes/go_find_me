import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:project_android/components/buttons.dart';
import 'package:project_android/themes/padding.dart';
import 'package:project_android/themes/textStyle.dart';
import 'package:project_android/themes/theme_colors.dart';

class ForgottenPasswordCodeConfirmation extends StatelessWidget {
  const ForgottenPasswordCodeConfirmation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ThemeColors.white,
        body: Container(
          padding: EdgeInsets.all(ThemePadding.padBase * 2),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: ThemeColors.primary,
                    radius: 20,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "GoFindMe",
                    style: TextStyle(
                        color: ThemeColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  )
                ],
              ),
              SizedBox(
                height: 60,
              ),
              Text(
                "Please enter a confirmation code to be able to change password",
                style: ThemeTexTStyle.regular(
                    color: ThemeColors.grey.withOpacity(0.5)),
              ),
              SizedBox(height: ThemePadding.padBase),
              //  model.lastEvent!.state == ForgotPasswordEventState.loading
              false
                  ? Center(
                      child: CircularProgressIndicator(
                        color: ThemeColors.primary,
                      ),
                    )
                  : Column(
                      children: [
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
                          // focusNode: verifyAccProv.pinPutFocusNode,
                          keyboardType: TextInputType.numberWithOptions(),
                          // controller: verifyAccProv.pinPutEmailController,
                          submittedFieldDecoration: BoxDecoration(
                            color: ThemeColors.primary.withOpacity(0.17),
                            border: Border.all(color: ThemeColors.primary),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        SizedBox(height: ThemePadding.padBase * 1.5),
                        ThemeButton.longButtonPrim(
                            text: "Send Code", onpressed: () {}),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
