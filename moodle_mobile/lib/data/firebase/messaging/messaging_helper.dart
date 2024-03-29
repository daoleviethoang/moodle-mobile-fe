import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moodle_mobile/data/notifications/notification_helper.dart';

class MessagingHelper {
  // region Init

  static Future initMessaging() async {
    // Listen to new messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      logMessage(message);
      await showMessageNotification(message);
    });
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
  }

  static Future onBackgroundMessage(message) async {
    logMessage(message);
    await showMessageNotification(message);
  }

  static logMessage(RemoteMessage message) {
    if (!kDebugMode) {
      return;
    }
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    if (message.notification != null) {
      print('Message also contained: ${message.notification}');
    }
  }

  static showMessageNotification(RemoteMessage message) async {
    var title = message.notification?.title ?? '';
    final body = message.notification?.body ?? '';
    if (title.isNotEmpty && body.isNotEmpty) {
      title += ': ';
    }
    await NotificationHelper.showTextNotification(title + body, message.data);
  }

  // endregion

  static Future checkPermission(BuildContext context) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    final notificationSettings = await messaging.getNotificationSettings();
    if (kDebugMode) {
      print('Current permission: ${notificationSettings.authorizationStatus}');
    }

    switch (notificationSettings.authorizationStatus) {
      case AuthorizationStatus.notDetermined:
        final newSettings = await messaging.requestPermission();
        if (kDebugMode) {
          print('New permission: ${newSettings.authorizationStatus}');
        }
        break;
      case AuthorizationStatus.denied:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)!.noti_permission)));
        break;
      case AuthorizationStatus.authorized:
      case AuthorizationStatus.provisional:
        break;
    }
  }
}