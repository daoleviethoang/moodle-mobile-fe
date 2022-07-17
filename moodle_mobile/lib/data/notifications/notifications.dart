import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:moodle_mobile/data/bg_service/bg_service.dart';
import 'package:moodle_mobile/models/calendar/event.dart';
import 'package:moodle_mobile/models/conversation/conversation.dart';
import 'package:moodle_mobile/models/notification/notification.dart';
import 'package:path_provider/path_provider.dart';

import 'channels.dart';

abstract class Notification {
  @required
  @mustCallSuper
  Future show(FlutterLocalNotificationsPlugin localNotifications) async {
    if (kDebugMode) {
      print('${BgService.logTag} sending notification of type: $runtimeType');
    }
  }
}

class TextNotification extends Notification {
  final String data;
  final Map<String, dynamic>? attachment;
  final details = const ImportantChannel();

  TextNotification(this.data, [this.attachment]) : super();

  @override
  Future show(FlutterLocalNotificationsPlugin localNotifications) async {
    super.show(localNotifications);
    int id = DateTime.now().millisecondsSinceEpoch ~/ 1000 ~/ 60;
    localNotifications.show(id, 'Moodle', data, details,
        payload: '${details.android?.channelId},$id,${jsonEncode(attachment)}');
  }
}

class CalendarNotification extends Notification {
  final Event data;
  final details = const CalendarChannel();

  CalendarNotification(this.data) : super();

  @override
  Future show(FlutterLocalNotificationsPlugin localNotifications) async {
    super.show(localNotifications);
    localNotifications.show(
      data.id ?? 0,
      data.name,
      data.description,
      details,
      payload: '${details.android?.channelId},${data.id},${data.instance}',
    );
  }
}

class MessengerNotification extends Notification {
  final ConversationModel data;

  MessengerNotification(this.data) : super();

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  @override
  Future show(FlutterLocalNotificationsPlugin localNotifications) async {
    super.show(localNotifications);

    // Get from member avatar
    final from =
        data.members.where((m) => m.id == data.message?.userIdFrom).first;
    final String? memberAvatarPath =
        await _downloadAndSaveFile(from.profileImageURL, '${from.id}');
    final details = MessengerChannel(memberAvatar: memberAvatarPath);

    // Show notification
    localNotifications.show(
      data.id,
      from.fullname,
      Bidi.stripHtmlIfNeeded(data.message?.text ?? ''),
      details,
      payload: '${details.android?.channelId},${data.id}',
    );
  }
}

class MoodleNotification extends Notification {
  final NotificationDetail data;
  final details = const NotificationsChannel();

  MoodleNotification(this.data) : super();

  @override
  Future show(FlutterLocalNotificationsPlugin localNotifications) async {
    super.show(localNotifications);
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