import 'dart:async';

import 'package:flutter/foundation.dart';

abstract class BaseProvider<T> with ChangeNotifier{
  final _streamController = StreamController<T>.broadcast();

  // Access the Stream
  Stream<T>  get stream => _streamController.stream;

  // Access the Sink
  Sink<T> get sink => _streamController.sink;

  T? _lastEvent;

  // Access the last Event in the Stream
  T? get lastEvent => _lastEvent;

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  //  Add latest event to stream
  void addEvent(T event){
    _lastEvent = event;
    notifyListeners();

    sink.add(event);
  }

  // clear state Data
  void clearData(){

  }
}