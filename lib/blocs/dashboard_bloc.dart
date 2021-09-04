import 'dart:async';

import 'package:project_android/locator.dart';
import 'package:project_android/models/PostModel.dart';
import 'package:project_android/services/api.dart';

class DashboardBloc {
  Api _api = sl<Api>();

  StreamController<List<Post>> feed = StreamController<List<Post>>.broadcast();
  Stream<List<Post>> get feedStream => feed.stream;
  Sink<List<Post>> get _feedSink => feed.sink;

  getFeedBody() async {
    List response = await _api.getFeed();

    List<Post> feed = response.map((e) => Post.fromJson(e)).toList();
    _feedSink.add(feed.reversed.toList());
  }
}
