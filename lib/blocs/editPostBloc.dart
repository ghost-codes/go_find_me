import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_android/blocs/authenticationBloc.dart';
import 'package:project_android/locator.dart';
import 'package:project_android/services/api.dart';

class EditPostBloc {
  // DashboardBloc dashboardBloc = sl<DashboardBloc>();
  List<XFile>? _images;
  List<dynamic>? oldImages;

  Api _api = sl<Api>();
  AuthenticationBloc authBloc = sl<AuthenticationBloc>();

  TextEditingController? postDescription;
  TextEditingController? lastSeenLocation;

  TextEditingController? title;

  DateTime lastSeenDate = DateTime.now();

  StreamController<List<dynamic>> _imagesStreamController =
      StreamController<List<dynamic>>.broadcast();
  Stream<List<dynamic>> get imagesStream => _imagesStreamController.stream;
  Sink<List<dynamic>> get _imagesSink => _imagesStreamController.sink;

  StreamController<String> status = StreamController<String>.broadcast();
  Stream<String> get statusStream => status.stream;
  Sink<String> get statusSink => status.sink;

  StreamController<DateTime> lastSeenDateController =
      StreamController<DateTime>.broadcast();
  Stream<DateTime> get lastSeenDateStream => lastSeenDateController.stream;
  Sink<DateTime> get lastSeenDateSink => lastSeenDateController.sink;

  onImageUpload() async {
    final ImagePicker _picker = ImagePicker();
    _images = await _picker.pickMultiImage();
    List<dynamic> memImages = [];

    memImages =
        await Future.wait(_images!.map((e) async => await e.readAsBytes()));

    _imagesSink.add(memImages);
  }

  removeImage(int index, List<dynamic> memImages) async {
    if (index >= oldImages!.length) {
      _images!.removeAt(oldImages!.length - index);
    } else {
      oldImages!.removeAt(index);
    }
    memImages.removeAt(index);

    _imagesSink.add(memImages);
  }

  onMoreImageUpload() async {
    final ImagePicker _picker = ImagePicker();
    _images = [..._images ?? [], ...(await _picker.pickMultiImage()) ?? []];
    List<dynamic> memImages = [...oldImages!];
    _images!.forEach((element) async {
      final e = await element.readAsBytes();
      memImages.add(e);
    });

    _imagesSink.add(memImages);
  }

  onSubmitPost(BuildContext context, String postId, String status) async {
    List<MultipartFile> files = [];
    _images?.forEach((element) async {
      files.add(MultipartFile.fromFileSync(element.path));
    });
    // String status = await statusStream.last;
    print("object");
    var response = await _api.editPost({
      "userId": authBloc.user?.id,
      "status": status,
      "desc": postDescription!.text,
      "title": title!.text,
      "imgs": oldImages,
      "uploads": files,
      "last_seen": {
        "location": lastSeenLocation!.text,
        "date": lastSeenDate.toIso8601String()
      }
    }, postId);
    if (response) Navigator.pop(context, true);
  }
}
