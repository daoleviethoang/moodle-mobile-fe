import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

import 'package:flutter_background_service_android/flutter_background_service_android.dart';

abstract class BgEvent {
  String event;
  void Function(Map<String, dynamic>? event)? onData;
  Function? onError;
  void Function()? onDone;
  bool? cancelOnError;

  BgEvent({
    required this.event,
    required this.onData,
    this.onError,
    this.onDone,
    this.cancelOnError,
  });
}

// region Built-in events

class SetAsForeground extends BgEvent {
  AndroidServiceInstance service;

  SetAsForeground(this.service) : super(
    event: 'setAsForeground',
    onData: (event) => service.setAsForegroundService(),
  );
}

class SetAsBackground extends BgEvent {
  AndroidServiceInstance service;

  SetAsBackground(this.service) : super(
    event: 'setAsBackground',
    onData: (event) => service.setAsBackgroundService(),
  );
}

class StopService extends BgEvent {
  ServiceInstance service;

  StopService(this.service) : super(
    event: 'stopService',
    onData: (event) => service.stopSelf(),
  );
}

// endregion

// region Moodle events

class FetchMessage extends BgEvent {
  FetchMessage() : super(
    event: 'fetchMessage',
    onData: (event) => print(event),
  );
}

class FetchNotification extends BgEvent {
  FetchNotification() : super(
    event: 'fetchNotification',
    onData: (event) => print(event),
  );
}

// endregion