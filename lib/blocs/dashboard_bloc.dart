import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_android/locator.dart';
import 'package:project_android/models/PostModel.dart';
import 'package:project_android/services/api.dart';

class DashboardBloc {
  Api _api = sl<Api>();

  List<Post>? currentData;

  StreamController<List<Post>> feed = StreamController<List<Post>>.broadcast();
  Stream<List<Post>> get feedStream => feed.stream;
  Sink<List<Post>> get _feedSink => feed.sink;

  StreamController<bool> reload = StreamController<bool>();
  Stream<bool> get reloadStream => reload.stream;
  Sink<bool> get reloadSink=> reload.sink;

  getFeedBody() async {
    if (currentData != null) {
      reloadSink.add(true);
    } 
      List response = await _api.getFeed();

      currentData = response.map((e) => Post.fromJson(e)).toList();
      _feedSink.add(currentData!.reversed.toList());
       if (currentData != null) {
      reloadSink.add(false);
    }
    
  }

  deletePost(String postId, BuildContext context) async {
    var response = await _api.deletePost(postId);
    if (response) {
      getFeedBody();
      Navigator.of(context).pop();
    }
  }
}
