import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_android/blocs/dashboard_bloc.dart';
import 'package:project_android/blocs/authenticationBloc.dart';

import 'package:project_android/components/dialogs.dart';
import 'package:project_android/core/network/networkError.dart';
import 'package:project_android/locator.dart';
import 'package:project_android/models/OnPopModel.dart';
import 'package:project_android/models/PostModel.dart';
import 'package:project_android/modules/base_provider.dart';
import 'package:project_android/services/api.dart';
import 'package:project_android/util/validators.dart';

enum CreatePostEventState { idle, loading, error, success }

class CreatePostEvent<T> {
  final CreatePostEventState state;
  final T? data;

  CreatePostEvent({required this.state, this.data});
}

// Create Post Provider
class CreatePostProvider extends BaseProvider<CreatePostEvent> {
  Api _api = sl<Api>();
  AuthenticationBloc _authBloc = sl<AuthenticationBloc>();

  DashboardBloc dashboardBloc = sl<DashboardBloc>();
  List<XFile>? _images = [];
  List<Uint8List> memImages = [];

  // Form Key
  GlobalKey<FormState> _formKey = GlobalKey();

  // Get formkey
  GlobalKey<FormState> get formKey => _formKey;

  // TextEditingController form
  TextEditingController title = TextEditingController();
  TextEditingController postDescription = TextEditingController();
  TextEditingController lastSeenLocation = TextEditingController();

  DateTime? _lastSeenDate = DateTime.now();
  DateTime? get lastSeenDate => _lastSeenDate;

  String? isEmptyValidator(String value, String Fieldname) {
    if (Validators.stringLengthValidator(value)) {
      return "Please enter value for $Fieldname field";
    }

    return null;
  }

  onCreatePost(BuildContext context) async {
    if (_images!.length < 2) {
      Dialogs.errorDialog(context, "Please add 2 or more images");
      return;
    }
    if (_formKey.currentState!.validate()) {
      addEvent(CreatePostEvent(state: CreatePostEventState.loading));
      try {
        List<MultipartFile> files = [];
        _images?.forEach((element) async {
          files.add(MultipartFile.fromFileSync(element.path));
        });

        Post? response = await _api.createPost({
          "userId": _authBloc.user?.id,
          "desc": postDescription.text,
          "title": title.text,
          "uploads": files,
          "last_seen": {
            "location": lastSeenLocation.text,
            "date": _lastSeenDate!.toIso8601String()
          }
        });

        if (response != null) {
          addEvent(CreatePostEvent(state: CreatePostEventState.success));
          Navigator.pop(context, OnPopModel(reloadPrev: true));
        }
      } on NetworkError catch (netErr) {
        addEvent(CreatePostEvent(
          state: CreatePostEventState.error,
        ));
        Dialogs.errorDialog(context, netErr.error);
      }
    }
  }

  onImageUpload() async {
    final ImagePicker _picker = ImagePicker();
    _images = await _picker.pickMultiImage();

    memImages =
        await Future.wait(_images!.map((e) async => await e.readAsBytes()));
    notifyListeners();
  }

  removeImage(int index) async {
    _images!.removeAt(index);
    memImages.removeAt(index);
    notifyListeners();
  }

  onMoreImageUpload() async {
    final ImagePicker _picker = ImagePicker();
    _images = [..._images ?? [], ...(await _picker.pickMultiImage()) ?? []];
    memImages = [];
    _images!.forEach((element) async {
      final e = await element.readAsBytes();
      memImages.add(e);
    });

    notifyListeners();
  }

  setLastSeenDate(DateTime? date) {
    _lastSeenDate = date;
    notifyListeners();
  }
}
