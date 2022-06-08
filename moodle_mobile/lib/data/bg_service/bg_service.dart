import 'dart:async';
import 'dart:ui';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/constants/vars.dart';
import 'package:moodle_mobile/data/notifications/notification_helper.dart';
import 'package:moodle_mobile/di/service_locator.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'bg_events.dart';

class BgService {
  static Future<void> initBackgroundService() async {
    // Register to receive BackgroundFetch events after app is terminated.
    // Requires {stopOnTerminate: false, enableHeadless: true}
    await initPlatformState();
    await BackgroundFetch.registerHeadlessTask(bgHeadlessTask);
  }

  static bgHeadlessTask(HeadlessTask task) async {
    String taskId = task.taskId;
    bool isTimeout = task.timeout;
    if (isTimeout) {
      onTimeOut(taskId);
    }
    onFetch(taskId);
  }

  static initPlatformState() async {
    int status = await BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 1,
        startOnBoot: true,
        stopOnTerminate: false,
        enableHeadless: true,
      ),
      onFetch,
      onTimeOut,
    );
    if (kDebugMode) {
      print('[BackgroundFetch] configure success: $status');
    }
    await BackgroundFetch.scheduleTask(TaskConfig(
      taskId: '${FetchMessage()}',
      delay: 5000,
      periodic: true,
      startOnBoot: true,
      stopOnTerminate: false,
      enableHeadless: true,
      requiresNetworkConnectivity: true,
    ));
  }

  static onFetch(String taskId) async {
    if (kDebugMode) {
      print("[BackgroundFetch] Event received $taskId");
    }
    if (taskId == '${FetchMessage()}') {
      if (kDebugMode) {
        print('FETCH Message!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
      }
    }
    BackgroundFetch.finish(taskId);
  }

  static onTimeOut(String taskId) async {
    if (kDebugMode) {
      print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
    }
    BackgroundFetch.finish(taskId);
  }
}

// class BgServiceOld {
//   static UserStore? _userStore;
//
//   static Timer? fetchingTimer;
//
//   static Future<void> initBackgroundService() async {
//     final service = FlutterBackgroundService();
//     await service.configure(
//       androidConfiguration: AndroidConfiguration(
//         onStart: onStart,
//         autoStart: true,
//         isForegroundMode: false,
//       ),
//       iosConfiguration: IosConfiguration(
//         autoStart: true,
//         onForeground: onStart,
//         onBackground: onIosBackground,
//       ),
//     );
//     service.startService();
//   }
//
//   // to ensure this executed
//   // run app from xcode, then from xcode menu, select Simulate Background Fetch
//   static bool onIosBackground(ServiceInstance service) {
//     WidgetsFlutterBinding.ensureInitialized();
//     if (kDebugMode) {
//       print('FLUTTER BACKGROUND SERVICE INITIALIZED');
//     }
//     return true;
//   }
//
//   static void onStart(ServiceInstance service) async {
//     // Only available for flutter 3.0.0 and later
//     if (Vars.isFlutter3Plus) {
//       DartPluginRegistrant.ensureInitialized();
//     }
//
//     // For flutter prior to version 3.0.0
//     // We have to register the plugin manually
//
//     registerBuiltInEvents(service);
//     registerMoodleEvents(service);
//     startFetchingTimer(service);
//
//     if (kDebugMode) {
//       print('FLUTTER BACKGROUND SERVICE INITIALIZED');
//     }
//   }
//
//   /// Listen to events sent by system
//   static void registerBuiltInEvents(ServiceInstance service) {
//     if (service is AndroidServiceInstance) {
//       final setAsForeground = SetAsForeground(service);
//       final setAsBackground = SetAsBackground(service);
//       service.on(setAsForeground.event).listen(setAsForeground.onData);
//       service.on(setAsBackground.event).listen(setAsBackground.onData);
//     }
//     final stopService = StopService(service);
//     service.on(stopService.event).listen(stopService.onData);
//   }
//
//   /// Listen to events sent by timers
//   static void registerMoodleEvents(ServiceInstance service) {
//     final fetchMessage = FetchMessage();
//     final fetchNotification = FetchNotification();
//     service.on(fetchMessage.event).listen((event) {
//       launchUrlString('https://www.google.com',
//           mode: LaunchMode.externalApplication);
//       fetchMessage.onData!(event);
//     });
//     service.on(fetchNotification.event).listen(fetchNotification.onData);
//   }
//
//   /// A timer for refreshing message & notification list
//   static void startFetchingTimer(ServiceInstance service) {
//     fetchingTimer = Timer.periodic(
//       Vars.refreshInterval,
//       (timer) async {
//         // Get token
//         if (_userStore == null) {
//           await setupLocator();
//           _userStore = GetIt.instance<UserStore>();
//         }
//
//         // Update persistent notification
//         if (service is AndroidServiceInstance) {
//           service.setForegroundNotificationInfo(
//             title: "Moodle App Service",
//             content: "Updated at ${DateTime.now()}",
//           );
//         }
//
//         // Invoke events
//         service.invoke(
//           '${FetchMessage()}',
//           {
//             'token': _userStore!.user.token,
//             'userId': _userStore!.user.id,
//           },
//         );
//         service.invoke(
//           '${FetchNotification()}',
//           {'token': _userStore!.user.token},
//         );
//       },
//     );
//   }
// }