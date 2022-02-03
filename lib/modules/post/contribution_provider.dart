import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_android/blocs/authenticationBloc.dart';

import 'package:project_android/components/dialogs.dart';
import 'package:project_android/core/network/networkError.dart';
import 'package:project_android/locator.dart';
import 'package:project_android/models/OnPopModel.dart';
import 'package:project_android/models/PostModel.dart';
import 'package:project_android/modules/auth/authProvider.dart';
import 'package:project_android/modules/base_provider.dart';
import 'package:project_android/services/api.dart';
import 'package:project_android/util/validators.dart';
import 'package:provider/provider.dart';

enum ContribuionEventState { idle, loading, error, success }

class ContributionsEvent<T> {
  final ContribuionEventState state;
  final T? data;

  ContributionsEvent({required this.state, this.data});
}

// Create Post Provider
class ContributionsProvider extends BaseProvider<ContributionsEvent> {
  Api _api = sl<Api>();

  DateTime? dateValue;
  DateTime? timeValue;
  String postId = '';

  TextEditingController locationController = TextEditingController();

  setDate(DateTime x) {
    dateValue = x;
    notifyListeners();
  }

  onSubmit(BuildContext context) async {
    var response = await _api.contribution({
      "location_sighted": locationController.text,
      "post_id": postId,
      "time_sighted": timeValue!.toIso8601String(),
      "date_sighted": (dateValue ?? DateTime.now()).toIso8601String(),
    });

    if (response != null) {
      Navigator.pop(context, OnPopModel(reloadPrev: true));
    }
  }
}
