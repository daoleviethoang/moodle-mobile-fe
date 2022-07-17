import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ImportantChannel extends NotificationDetails {
  const ImportantChannel()
      : super(
          android: const AndroidNotificationDetails('imp', 'Important',
              channelDescription: 'Important messages sent from server',
              priority: Priority.high),
          iOS: const IOSNotificationDetails(),
        );
}

class CalendarChannel extends NotificationDetails {
  const CalendarChannel()
      : super(
          android: const AndroidNotificationDetails('cal', 'Calendar',
              channelDescription:
                  'Submission & quizzes events on Moodle calendar'),
          iOS: const IOSNotificationDetails(),
        );
}

class MessengerChannel extends NotificationDetails {
  final String? memberAvatar;
  final String? memberAvatarBase64;

  MessengerChannel({this.memberAvatar, this.memberAvatarBase64})
      : super(
          android: AndroidNotificationDetails(
            'mes',
            'Messenger',
            channelDescription: 'Messages received in Moodle',
            // FIXME: Failed to create image decoder with message 'unimplemented'
            largeIcon: memberAvatarBase64 != null
                ? ByteArrayAndroidBitmap.fromBase64String(memberAvatarBase64)
                : null,
          ),
          iOS: const IOSNotificationDetails(),
        );
}

class NotificationsChannel extends NotificationDetails {
  const NotificationsChannel()
      : super(
          android: const AndroidNotificationDetails('not', 'Notifications',
              channelDescription: 'Notifications fetched from Moodle'),
          iOS: const IOSNotificationDetails(),
        );
}