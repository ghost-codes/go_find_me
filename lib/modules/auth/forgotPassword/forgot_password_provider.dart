import 'package:flutter/material.dart';
import 'package:project_android/core/network/networkError.dart';
import 'package:project_android/locator.dart';
import 'package:project_android/modules/base_provider.dart';
import 'package:project_android/services/api.dart';

enum ForgotPasswordEventState { idle, loading, error, success }

class ForgotPasswordEvent<T> {
  final T? data;
  final ForgotPasswordEventState state;
  ForgotPasswordEvent({this.data, required this.state});
}

class ForgotPasswordProvider extends BaseProvider<ForgotPasswordEvent> {
  Api _api = sl<Api>();

  TextEditingController _emailField = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController get emailFeld => _emailField;
  GlobalKey<FormState> get formKey => _formKey;

  ForgotPasswordProvider() {
    addEvent(ForgotPasswordEvent(state: ForgotPasswordEventState.idle));
  }

  Future<void> onSubmitEmail() async {
    final _formState = formKey.currentState;
    if (!_formState!.validate()) return;

    try {
      addEvent(ForgotPasswordEvent(state: ForgotPasswordEventState.loading));
      await _api.sendForgotPasswordCode(_emailField.text);
      addEvent(ForgotPasswordEvent(state: ForgotPasswordEventState.success));
    } on NetworkError catch (error) {
      addEvent(ForgotPasswordEvent(
          state: ForgotPasswordEventState.error, data: error.errorMessage));
    }
  }
}
