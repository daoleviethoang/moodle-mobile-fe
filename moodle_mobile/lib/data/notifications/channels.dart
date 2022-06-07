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
  const MessengerChannel()
      : super(
          android: const AndroidNotificationDetails('mes', 'Messenger',
              channelDescription: 'Messages received in Moodle'),
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