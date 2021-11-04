import 'package:flutter/material.dart';
import 'package:project_android/components/dialogs.dart';
import 'package:project_android/core/network/networkError.dart';
import 'package:project_android/locator.dart';
import 'package:project_android/models/PostModel.dart';
import 'package:project_android/modules/base_provider.dart';
import 'package:project_android/services/api.dart';

enum DashBoardEventState { idel, isloading, error, success }

class DashBoardEvent<T> {
  final DashBoardEventState state;
  final T? data;

  DashBoardEvent({required this.state, this.data});
}

class DashboardProvider extends BaseProvider<DashBoardEvent> {
  bool confirmDelete = false;

  DashboardProvider() {
    getFeedBody();
  }

  Api _api = sl<Api>();
  bool reload = false;
  List<Post?>? currentData;

  getFeedBody() async {
    addEvent(DashBoardEvent(state: DashBoardEventState.isloading));

    List<Post?> response = await _api.getFeed();
    if (response == null) {
      addEvent(DashBoardEvent(state: DashBoardEventState.error));
      return;
    }
    currentData = response.reversed.toList();
    addEvent(DashBoardEvent(state: DashBoardEventState.success));
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
