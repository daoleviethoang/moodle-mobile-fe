import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:moodle_mobile/data/notifications/notifications.dart';
import 'package:moodle_mobile/models/calendar/event.dart';
import 'package:moodle_mobile/models/conversation/conversation.dart';
import 'package:moodle_mobile/models/notification/notification.dart';
import 'package:url_launcher/url_launcher.dart';

import 'channels.dart';

class NotificationHelper {
  static FlutterLocalNotificationsPlugin? _localNotifications;

  static Future initNotificationService() async {
    _localNotifications = FlutterLocalNotificationsPlugin();
    const androidSettings = AndroidInitializationSettings('ic_launcher');
    const iosSettings = IOSInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _localNotifications!.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );
  }

  static Future onSelectNotification(String? payload) async {
    if (payload != null) {
      // Get data
      final payloadData = payload.split(',');
      final channel = payloadData[0];
      final id = payloadData[1];
      final data =
          (payloadData.length > 2) ? payloadData.sublist(2).join(',') : '';
      if (kDebugMode) {
        print('notification payload: $payload');
        print('channel: $channel');
        print('id: $id');
        print('data: $data');
      }

      // Analyze data
      if (channel == const ImportantChannel().android!.channelId) {
        final dataMap = jsonDecode(data) as Map<String, dynamic>;
        if (dataMap.containsKey('url')) {
          await launchUrl(
            Uri.parse(dataMap['url']),
            mode: LaunchMode.externalApplication,
          );
        }
      }
    }
  }

  static Future showTextNotification(String data,
          [Map<String, dynamic>? attachment]) async =>
      TextNotification(data, attachment).show(_localNotifications!);

  static Future showCalendarNotification(Event data) async =>
      CalendarNotification(data).show(_localNotifications!);

  static Future showMessengerNotification(ConversationModel data) async =>
      MessengerNotification(data).show(_localNotifications!);

  static Future showMoodleNotification(NotificationDetail data) async =>
      MoodleNotification(data).show(_localNotifications!);
}