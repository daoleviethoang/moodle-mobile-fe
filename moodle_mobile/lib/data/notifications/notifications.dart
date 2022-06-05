import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:moodle_mobile/models/calendar/event.dart';
import 'package:moodle_mobile/models/conversation/conversation.dart';
import 'package:moodle_mobile/models/notification/notification.dart';

import 'channels.dart';

class CalendarNotification {
  final Event data;
  final details = const CalendarChannel();

  CalendarNotification(this.data) : super();

  Future show(FlutterLocalNotificationsPlugin localNotifications) async {
    localNotifications.show(
      data.id ?? 0,
      data.name,
      data.description,
      details,
      payload: '${details.android?.channelId},${data.id},${data.instance}',
    );
  }
}

class MessengerNotification {
  final ConversationModel data;
  final details = const MessengerChannel();

  MessengerNotification(this.data) : super();

  Future show(FlutterLocalNotificationsPlugin localNotifications) async {
    final sender = data.members
        .where((m) => m.id == data.message?.userIdFrom)
        .first
        .fullname;
    localNotifications.show(
      data.id,
      sender,
      data.message?.text,
      details,
      payload: '${details.android?.channelId},${data.id}',
    );
  }
}

class MoodleNotification {
  final NotificationDetail data;
  final details = const NotificationsChannel();

  MoodleNotification(this.data) : super();

  Future show(FlutterLocalNotificationsPlugin localNotifications) async {
    localNotifications.show(
      data.id ?? 0,
      data.subject,
      data.smallmessage,
      details,
      payload:
          '${details.android?.channelId},${data.customdata?.courseId},${data.customdata?.cmid}',
    );
  }
}