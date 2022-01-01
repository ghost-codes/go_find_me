import 'package:flutter/material.dart';
import 'package:project_android/components/dialogs.dart';
import 'package:project_android/core/network/networkError.dart';
import 'package:project_android/locator.dart';
import 'package:project_android/models/PostModel.dart';
import 'package:project_android/models/PostQueryResponse.dart';
import 'package:project_android/modules/base_provider.dart';
import 'package:project_android/services/api.dart';

enum DashBoardEventState { idel, isloading, error, success }

class DashBoardEvent<T> {
  final DashBoardEventState state;
  final T? data;

  DashBoardEvent({required this.state, this.data});
}

class DashboardProvider extends BaseProvider<DashBoardEvent> {
  BuildContext rootContext;
  bool confirmDelete = false;

  DashboardProvider({required this.rootContext}) {
    getFeedBody();
  }

  Api _api = sl<Api>();
  bool reload = false;
  List<Post?>? currentData;
  String? nextPostPage;

  getFeedBody() async {
    addEvent(DashBoardEvent(state: DashBoardEventState.isloading));

    try {
      PostQueryResponse response = await _api.getFeed();
      currentData = response.posts;
      nextPostPage = response.next;
      if (response == null) {
        addEvent(DashBoardEvent(state: DashBoardEventState.error));
        return;
      }
    
      addEvent(DashBoardEvent(state: DashBoardEventState.success));
    } on NetworkError catch (netErr) {
      addEvent(DashBoardEvent(state: DashBoardEventState.error));
      Dialogs.errorDialog(rootContext, netErr.error);
    }
  }

  deletePost(String postId, BuildContext context) async {
    addEvent(DashBoardEvent(state: DashBoardEventState.isloading));

    try {
      var response = await _api.deletePost(postId);

      Navigator.of(context).pop();
      currentData?.removeWhere((element) => element?.id == postId);
      addEvent(DashBoardEvent(state: DashBoardEventState.success));
    } on NetworkError catch (err) {
      addEvent(DashBoardEvent(state: DashBoardEventState.error));
      Dialogs.errorDialog(context, err.error);
      Navigator.of(context).pop();
    }
  }
}
