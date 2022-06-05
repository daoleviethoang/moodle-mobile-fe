import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:moodle_mobile/data/notifications/notifications.dart';
import 'package:moodle_mobile/models/calendar/event.dart';
import 'package:moodle_mobile/models/conversation/conversation.dart';
import 'package:moodle_mobile/models/notification/notification.dart';

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
      onSelectNotification: selectNotification,
    );
  }

  static Future selectNotification(String? payload) async {
    if (payload != null) {
      print('notification payload: $payload');
    }
  }

  static Future showCalendarNotification(Event data) async =>
      CalendarNotification(data).show(_localNotifications!);

  static Future showMessengerNotification(ConversationModel data) async =>
      MessengerNotification(data).show(_localNotifications!);

  static Future showMoodleNotification(NotificationDetail data) async =>
      MoodleNotification(data).show(_localNotifications!);
}