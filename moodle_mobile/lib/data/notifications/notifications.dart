import 'dart:convert';
import 'dart:io';

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
  final int minutesLeft;
  final details = const CalendarChannel();

  CalendarNotification(this.data, this.minutesLeft) : super();

  String _parseDuration(Duration d, String locale) {
    String dayString = 'd', hourString = 'h', minuteString = 'm';
    if (locale.startsWith('en')) {
      dayString = 'day(s)';
      hourString = 'hour(s)';
      minuteString = 'minutes';
    } else if (locale.startsWith('vi')) {
      dayString = 'ngày';
      hourString = 'giờ';
      minuteString = 'phút';
    }
    final daysLeft = d.inDays > 0 ? '${d.inDays} $dayString ' : '';
    final hoursLeft = (d.inHours % 24) > 0 ? '${d.inHours} $hourString ' : '';
    final minutesLeft =
        (d.inMinutes % 60) > 0 ? '${d.inMinutes} $minuteString ' : '';
    if (locale.startsWith('en')) {
      return '$daysLeft$hoursLeft$minutesLeft til due time.';
    } else if (locale.startsWith('vi')) {
      return 'Còn $daysLeft$hoursLeft$minutesLeft';
    } else {
      return '$daysLeft$hoursLeft$minutesLeft';
    }
  }

  @override
  Future show(FlutterLocalNotificationsPlugin localNotifications) async {
    super.show(localNotifications);
    final locale = Platform.localeName;
    final description = _parseDuration(Duration(minutes: minutesLeft), locale);
    localNotifications.show(
      data.id ?? 0,
      data.name,
      description,
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

  Future<String> _downloadAndGetBase64(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    return base64Encode(response.bodyBytes);
  }

  @override
  Future show(FlutterLocalNotificationsPlugin localNotifications) async {
    super.show(localNotifications);

    // Get from member avatar
    final from =
        data.members.where((m) => m.id == data.message?.userIdFrom).first;
    // final String? memberAvatarPath =
    //     await _downloadAndSaveFile(from.profileImageURL, '${from.id}');
    print(from.profileImageURL);
    final base64 = await _downloadAndGetBase64(from.profileImageURL);
    final details = MessengerChannel(memberAvatarBase64: base64);

    // Show notification
    var text = Bidi.stripHtmlIfNeeded(data.message?.text ?? '').trim();
    if (text.isEmpty) text = '🖼';
    localNotifications.show(
      data.id,
      from.fullname,
      text,
      details,
      payload: '${details.android?.channelId},${data.id}',
    );
  }
}

class MoodleNotification extends Notification {
  final NotificationDetail data;
  final String courseName;
  final details = const NotificationsChannel();

  MoodleNotification(this.data, [this.courseName = '']) : super();

  @override
  Future show(FlutterLocalNotificationsPlugin localNotifications) async {
    super.show(localNotifications);
    localNotifications.show(
      data.id ?? 0,
      courseName,
      data.smallmessage,
      details,
      payload:
          '${details.android?.channelId},${data.customdata?.courseId},${data.customdata?.cmid}',
    );
  }
}