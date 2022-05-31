import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:moodle_mobile/constants/vars.dart';

import 'bg_events.dart';

class BgService {
  static Future<void> initBackgroundService() async {
    final service = FlutterBackgroundService();
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: false,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );
    service.startService();
  }

  // to ensure this executed
  // run app from xcode, then from xcode menu, select Simulate Background Fetch
  static bool onIosBackground(ServiceInstance service) {
    WidgetsFlutterBinding.ensureInitialized();
    if (kDebugMode) {
      print('FLUTTER BACKGROUND SERVICE INITIALIZED');
    }
    return true;
  }

  static void onStart(ServiceInstance service) async {
    // Only available for flutter 3.0.0 and later
    if (Vars.isFlutter3Plus) {
      DartPluginRegistrant.ensureInitialized();
    }

    // For flutter prior to version 3.0.0
    // We have to register the plugin manually

    registerBuiltInEvents(service);
    registerMoodleEvents(service);
    startFetchingTimer(service);

    if (kDebugMode) {
      print('FLUTTER BACKGROUND SERVICE INITIALIZED');
    }
  }

  /// Listen to events sent by system
  static void registerBuiltInEvents(ServiceInstance service) {
    if (service is AndroidServiceInstance) {
      final setAsForeground = SetAsForeground(service);
      final setAsBackground = SetAsBackground(service);
      service.on(setAsForeground.event).listen(setAsForeground.onData);
      service.on(setAsBackground.event).listen(setAsBackground.onData);
    }
    final stopService = StopService(service);
    service.on(stopService.event).listen(stopService.onData);
  }

  /// Listen to events sent by timers
  static void registerMoodleEvents(ServiceInstance service) {
    final fetchMessage = FetchMessage();
    final fetchNotification = FetchNotification();
    service.on(fetchMessage.event).listen(fetchMessage.onData);
    service.on(fetchNotification.event).listen(fetchNotification.onData);
  }

  /// A timer for refreshing message & notification list
  static void startFetchingTimer(ServiceInstance service) {
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (service is AndroidServiceInstance) {
        service.setForegroundNotificationInfo(
          title: "Moodle App Service",
          content: "Updated at ${DateTime.now()}",
        );
      }
      service.invoke(FetchMessage().event);
      service.invoke(FetchNotification().event);
    });
  }
}