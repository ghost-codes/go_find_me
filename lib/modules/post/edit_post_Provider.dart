import 'dart:async';
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

enum EditPostEventState { idle, loading }

class EditPostEvent<T> {
  final EditPostEventState state;
  final T? data;

  EditPostEvent({required this.state, this.data});
}

// Create Post Provider
class EditPostProvider extends BaseProvider<EditPostEvent> {
  Post? post;

  TextEditingController? title;
  TextEditingController? postDescription;
  TextEditingController? lastSeenLocation;
  DateTime? _lastSeenDate;
  List<String>? oldImages = [];

  GlobalKey<FormState> _formKey = GlobalKey();

  // Get formkey
  GlobalKey<FormState> get formKey => _formKey;

  DateTime? get lastSeenDate => _lastSeenDate;

  EditPostProvider({this.post}) {
    title = TextEditingController(text: post?.title);
    lastSeenLocation = TextEditingController(text: post?.lastSeen?.location);
    postDescription = TextEditingController(text: post?.desc);
    _lastSeenDate = post?.lastSeen?.date;
    oldImages = post?.imgs;
    displayImages = [...oldImages!];
    addEvent(EditPostEvent(state: EditPostEventState.idle));
  }

  Api _api = sl<Api>();
  AuthenticationBloc _authBloc = sl<AuthenticationBloc>();

  DashboardBloc dashboardBloc = sl<DashboardBloc>();

  List<XFile>? _images = [];
  List<Uint8List> memImages = [];
  List<dynamic> displayImages = [];

  // Form Key

  String? isEmptyValidator(String value, String Fieldname) {
    if (Validators.stringLengthValidator(value)) {
      return "Please enter value for $Fieldname field";
    }

    return null;
  }

  onImageUpload() async {
    print(displayImages.length);
    final ImagePicker _picker = ImagePicker();
    _images = [..._images ?? [], ...(await _picker.pickMultiImage()) ?? []];
    print(_images!.length);

    memImages = await Future.wait(
        _images!.map((e) async => await e.readAsBytes()).toList());

    displayImages = [...oldImages!, ...memImages];
    print(displayImages.length);

    notifyListeners();
  }

  removeImage(int index) async {
    if (index < oldImages!.length) {
      oldImages!.removeAt(index);
    } else {
      _images!.removeAt(index - oldImages!.length);
      memImages.removeAt(index - oldImages!.length);
    }

    displayImages = [...oldImages!, ...memImages];
    notifyListeners();
  }

  onSubmitPost(BuildContext context, String postId, String status) async {
    if ((_images!.length + oldImages!.length) < 2) {
      Dialogs.errorDialog(context, "Please add 2 or more images");
      return;
    }
    if (formKey.currentState!.validate()) {
      List<MultipartFile> files = [];
      _images?.forEach((element) async {
        files.add(MultipartFile.fromFileSync(element.path));
      });

      addEvent(EditPostEvent(state: EditPostEventState.loading));

      try {
        var response = await _api.editPost({
          "userId": _authBloc.user?.id,
          "status": status,
          "desc": postDescription!.text,
          "title": title!.text,
          "imgs": oldImages,
          "uploads": files,
          "last_seen": {
            "location": lastSeenLocation!.text,
            "date": lastSeenDate!.toIso8601String()
          }
        }, postId);
        if (response) Navigator.pop(context, true);
      } on NetworkError catch (err) {
        Dialogs.errorDialog(context, err.errorMessage!);
      }
    }

    addEvent(EditPostEvent(state: EditPostEventState.idle));
  }

  setLastSeenDate(DateTime? date) {
    _lastSeenDate = date;
    notifyListeners();
  }
}
