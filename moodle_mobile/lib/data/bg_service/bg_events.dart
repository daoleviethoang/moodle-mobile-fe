import 'dart:convert';

import 'package:background_fetch/background_fetch.dart';

import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/data/notifications/notification_helper.dart';
import 'package:moodle_mobile/models/conversation/conversation.dart';
import 'package:moodle_mobile/models/notification/last_updated_data.dart';
import 'package:moodle_mobile/store/conversation/conversation_store.dart';

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
            final store = GetIt.instance<ConversationStore>();
            await store.getListConversation(token, int.parse(uid));
            List<ConversationModel> cv = store.listConversation;
            for (ConversationModel c in cv) {
              // Notify latest message
              if (!c.isRead) {
                final msgData = lastUpdated.messages;
                final id = c.message?.userIdFrom ?? -1;
                final messageContent = c.message?.text ?? '';
                if (msgData[id] != c.message?.text &&
                    messageContent.isNotEmpty) {
                  await NotificationHelper.showMessengerNotification(c);
                  lastUpdated.addMessage(id, messageContent);
                }
              }
            }
            return lastUpdated;
          },
        );
}

class FetchNotification extends BgEvent {
  FetchNotification()
      : super(
          event: 'fetchNotification',
          onData: (event) async {
            print('fetchNotification');
            print(event);
            return null;
          },
        );
}

class FetchCalendar extends BgEvent {
  FetchCalendar()
      : super(
          event: 'fetchCalendar',
          onData: (event) async {
            print('fetchCalendar');
            print(event);
            return null;
          },
        );
}