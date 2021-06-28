import 'dart:async';

import 'package:flutter/material.dart';

enum RouterAction {
  Dashboard,
  Create,
  Profile,
}

class HomeBloc {
  int? routeNumber;

  PageController pageController = PageController(initialPage: 0);

  StreamController<int> routeStreamcontroller =
      StreamController<int>.broadcast();

  Stream<int> get routeStream => routeStreamcontroller.stream;
  StreamSink<int> get _routeSink => routeStreamcontroller.sink;

  StreamController<RouterAction> routeActionStreamController =
      StreamController.broadcast();
  Stream<RouterAction> get _routeActionSream =>
      routeActionStreamController.stream;
  StreamSink<RouterAction> get routeActionSink =>
      routeActionStreamController.sink;

  HomeBloc() {
    routeNumber = 0;

    _routeActionSream.listen((RouterAction event) {
      switch (event) {
        case RouterAction.Dashboard:
          {
            changeRoute(0);
          }
          break;
        case RouterAction.Create:
          {
            changeRoute(1);
          }
          break;
        case RouterAction.Profile:
          {
            changeRoute(2);
          }
          break;
      }
    });
  }

  void changeRoute(int page) {
    pageController.jumpToPage(page);
    print(pageController.page);
  }
}
