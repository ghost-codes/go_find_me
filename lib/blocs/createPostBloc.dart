import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_android/blocs/authenticationBloc.dart';
import 'package:project_android/blocs/dashboard_bloc.dart';
import 'package:project_android/blocs/home_bloc.dart';
import 'package:project_android/locator.dart';
import 'package:project_android/services/api.dart';

enum CreatePostActions { CreatePost }

class CreatePostBloc {
  Api _api = sl<Api>();
  AuthenticationBloc _authBloc = sl<AuthenticationBloc>();

  HomeBloc homeBloc = sl<HomeBloc>();
  DashboardBloc dashboardBloc = sl<DashboardBloc>();
  List<XFile>? _images;

  TextEditingController postDescription = TextEditingController();
  TextEditingController lastSeenLocation = TextEditingController();

  TextEditingController title = TextEditingController();

  StreamController<CreatePostActions> createPostActions =
      StreamController.broadcast();
  DateTime lastSeenDate = DateTime.now();

  Stream<CreatePostActions> get _createPostActionsStream =>
      createPostActions.stream;
  StreamSink<CreatePostActions> get createPostActionsSink =>
      createPostActions.sink;

  StreamController<List<Uint8List>> _imagesStreamController =
      StreamController<List<Uint8List>>.broadcast();
  Stream<List<Uint8List>> get imagesStream => _imagesStreamController.stream;
  Sink<List<Uint8List>> get _imagesSink => _imagesStreamController.sink;

  StreamController<DateTime> lastSeenDateController =
      StreamController<DateTime>.broadcast();
  Stream<DateTime> get lastSeenDateStream => lastSeenDateController.stream;
  Sink<DateTime> get lastSeenDateSink => lastSeenDateController.sink;

  StreamController<bool> pageState = StreamController.broadcast();
  Stream<bool> get pageStateStream => pageState.stream;
  Sink<bool> get pageStateSink => pageState.sink;

  dispose() {
    createPostActions.close();
    _imagesStreamController.close();
    lastSeenDateController.close();
    pageState.close();
  }

  onCreatePost(BuildContext context) async {
    pageStateSink.add(true);
    List<MultipartFile> files = [];
    _images?.forEach((element) async {
      files.add(MultipartFile.fromFileSync(element.path));
    });

    var response = await _api.createPost({
      "userId": _authBloc.user?.id,
      "desc": postDescription.text,
      "title": title.text,
      "uploads": files,
      "last_seen": {
        "location": lastSeenLocation.text,
        "date": lastSeenDate.toIso8601String()
      }
    });

    if (response != null) {
      dashboardBloc.getFeedBody();
      pageStateSink.add(false);
      Navigator.pop(context);
    }
    pageStateSink.add(false);
  }

  onImageUpload() async {
    final ImagePicker _picker = ImagePicker();
    _images = await _picker.pickMultiImage();
    List<Uint8List> memImages = [];

    memImages =
        await Future.wait(_images!.map((e) async => await e.readAsBytes()));

    _imagesSink.add(memImages);
  }

  removeImage(int index, List<Uint8List> memImages) async {
    _images!.removeAt(index);
    memImages.removeAt(index);

    _imagesSink.add(memImages);
  }

  onMoreImageUpload() async {
    final ImagePicker _picker = ImagePicker();
    _images = [
      ..._images ?? [],
      ...(await _picker.pickMultiImage(imageQuality: 8 - _images!.length)) ?? []
    ];
    List<Uint8List> memImages = [];
    _images!.forEach((element) async {
      final e = await element.readAsBytes();
      memImages.add(e);
    });

    _imagesSink.add(memImages);
  }

  CreatePostBloc() {
    _createPostActionsStream.listen((CreatePostActions action) {
      switch (action) {
        case CreatePostActions.CreatePost:
          // onCreatePost();
          break;
        default:
      }
    });
  }
}
