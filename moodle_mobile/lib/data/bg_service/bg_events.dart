import 'package:background_fetch/background_fetch.dart';
import 'package:dio/dio.dart';

import 'package:moodle_mobile/data/network/apis/calendar/calendar_service.dart';
import 'package:moodle_mobile/data/network/apis/conversation/conversation_api.dart';
import 'package:moodle_mobile/data/network/apis/course/course_detail_service.dart';
import 'package:moodle_mobile/data/network/apis/course/course_service.dart';
import 'package:moodle_mobile/data/network/apis/notification/notification_api.dart';
import 'package:moodle_mobile/data/network/dio_client.dart';
import 'package:moodle_mobile/data/notifications/notification_helper.dart';
import 'package:moodle_mobile/models/calendar/event.dart';
import 'package:moodle_mobile/models/conversation/conversation.dart';
import 'package:moodle_mobile/models/course/course.dart';
import 'package:moodle_mobile/models/notification/last_updated_data.dart';
import 'package:moodle_mobile/models/notification/notification.dart';

/// A preset of events that can be listened for by BgService
abstract class BgEvent {
  final String event;
  final Future<LastUpdateData?> Function(Map<String, dynamic>? event) onData;
  final Function(Object error)? onError;
  final void Function()? onDone;
  final bool? cancelOnError;

  BgEvent({
    required this.event,
    required this.onData,
    this.onError,
    this.onDone,
    this.cancelOnError,
  });

  @override
  String toString() => event;

  Future register([int? id]) => BackgroundFetch.scheduleTask(TaskConfig(
        taskId: '$event${id ?? ''}',
        delay: 15 * 60 * 1000,
        periodic: true,
        startOnBoot: true,
        stopOnTerminate: false,
        enableHeadless: true,
        // requiresNetworkConnectivity: true,
      ));
}

class FetchAll extends BgEvent {
  FetchAll() : super(event: 'fetchAll', onData: (event) async => null);
}

class FetchMessage extends BgEvent {
  FetchMessage()
      : super(
          event: 'fetchMessage',
          onData: (event) async {
            if (event == null) {
              throw (Exception('Data is null'));
            }
            final token = '${event['token']}';
            final uid = '${event['userid']}';
            LastUpdateData lastUpdated = event['lastUpdated'];

            // Get list of conversations
            final conversationApi = ConversationApi(DioClient(Dio()));
            List<ConversationModel> cv = await conversationApi
                .getConversationInfo(token, int.parse(uid));
            for (ConversationModel c in cv) {
              // Notify latest message
              if (c.isRead) continue;
              final msgData = lastUpdated.messages;
              final id = c.message?.userIdFrom ?? -1;
              final messageContent = c.message?.text ?? '';
              if (msgData[id] != messageContent && messageContent.isNotEmpty) {
                await NotificationHelper.showMessengerNotification(c);
                lastUpdated.addMessage(id, messageContent);
              }
            }
            return lastUpdated;
          },
        );
}

class FetchCalendar extends BgEvent {
  static const List<int> minutes = [
    60 * 24 * 7,
    60 * 24 * 2,
    60 * 24,
    60 * 12,
    60 * 6,
    60 * 2,
    60,
    30,
    15,
  ];

  FetchCalendar()
      : super(
          event: 'fetchNotification',
          onData: (event) async {
            if (event == null) {
              throw (Exception('Data is null'));
            }
            final token = '${event['token']}';
            final uid = '${event['userid']}';
            LastUpdateData lastUpdated = event['lastUpdated'];

            // Get list of upcoming events in enrolled courses (last 2 months)
            var courses =
                await CourseService().getCourses(token, int.parse(uid));
            courses = courses.where((c) {
              final startDate =
                  DateTime.fromMillisecondsSinceEpoch(c.startdate * 1000);
              final diff = DateTime.now().difference(startDate);
              return diff.inDays < 30 * 6 + 5;
            }).toList();
            final events = <Event>[];
            for (Course course in courses) {
              events.addAll(await CalendarService()
                  .getUpcomingByCourse(token, course.id));
            }
            for (Event e in events) {
              // Get last notified minute
              final time = DateTime.fromMillisecondsSinceEpoch(
                  (e.timestart ?? 0) * 1000);
              final evData = lastUpdated.events;
              final id = e.id ?? -1;
              final lastNotified = evData[id];
              if (lastNotified == minutes.last) continue;

              // Get next notify minute
              final now = DateTime.now();
              final nextIndex = minutes.lastIndexWhere((m) {
                final nextTime = time.subtract(Duration(minutes: m));
                return now.isAfter(nextTime);
              });
              if (nextIndex == -1) continue;
              final nextNotify = minutes[nextIndex];

              // Notify event with minutes left
              await NotificationHelper.showCalendarNotification(e,
                  minutesLeft: nextNotify);
              lastUpdated.addEvent(id, nextNotify);
            }
            return lastUpdated;
          },
        );
}

class FetchNotification extends BgEvent {
  FetchNotification()
      : super(
          event: 'fetchCalendar',
          onData: (event) async {
            if (event == null) {
              throw (Exception('Data is null'));
            }
            final token = '${event['token']}';
            final uid = '${event['userid']}';
            LastUpdateData lastUpdated = event['lastUpdated'];

            // Get list of upcoming events in enrolled courses (last 2 months)
            final notificationPopup = await NotificationApi.fetchPopup(token);
            final details = notificationPopup?.notificationDetail ?? [];
            for (NotificationDetail d in details) {
              if (d.read ?? false) continue;
              // Get course name
              final courseId = d.customdata?.courseId ?? '-1';
              final course = await CourseDetailService()
                  .getCourseById(token, int.parse(courseId));
              final courseName = course.displayname ?? '';

              // Notify latest notification
              final id = d.id ?? -1;
              final messageContent = d.fullmessage ?? '';
              final notiData = lastUpdated.notifications;
              if (notiData.contains(id) && messageContent.isNotEmpty) {
                await NotificationHelper.showMoodleNotification(
                  d,
                  courseName: courseName,
                );
                lastUpdated.addNotification(id);
              }
            }
            return lastUpdated;
          },
        );
}