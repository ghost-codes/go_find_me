import 'dart:async';

import 'package:flutter/material.dart';

enum CreatePostActions { CreatePost }

class CreatePostBloc {
  TextEditingController postDescription = TextEditingController();

  TextEditingController title = TextEditingController();

  StreamController<CreatePostActions> createPostActions = StreamController();

  Stream<CreatePostActions> get _createPostActionsStream =>
      createPostActions.stream;

  StreamSink<CreatePostActions> get createPostActionsSink =>
      createPostActions.sink;

  onCreatePost() {
    print("Description  " + postDescription.text);
    print("Title  " + title.text);
  }

  CreatePostBloc() {
    _createPostActionsStream.listen((CreatePostActions action) {
      switch (action) {
        case CreatePostActions.CreatePost:
          onCreatePost();
          break;
        default:
      }
    });
  }
}
