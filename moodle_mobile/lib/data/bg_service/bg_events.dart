import 'package:flutter_background_service/flutter_background_service.dart';

import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/data/notifications/notification_helper.dart';
import 'package:moodle_mobile/models/conversation/conversation.dart';
import 'package:moodle_mobile/store/conversation/conversation_store.dart';

/// A preset of events that can be listened for by BgService
abstract class BgEvent {
  final String event;
  final void Function(Map<String, dynamic>? event)? onData;
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
}

// region Built-in events

class SetAsForeground extends BgEvent {
  AndroidServiceInstance service;

  SetAsForeground(this.service)
      : super(
          event: 'setAsForeground',
          onData: (event) => service.setAsForegroundService(),
        );
}

class SetAsBackground extends BgEvent {
  AndroidServiceInstance service;

  SetAsBackground(this.service)
      : super(
          event: 'setAsBackground',
          onData: (event) => service.setAsBackgroundService(),
        );
}

class StopService extends BgEvent {
  ServiceInstance service;

  StopService(this.service)
      : super(
          event: 'stopService',
          onData: (event) => service.stopSelf(),
        );
}

// endregion

// region Moodle events

class FetchMessage extends BgEvent {
  FetchMessage()
      : super(
          event: 'fetchMessage',
          onData: (event) async {
            if (event == null) {
              throw(Exception('Data is null'));
            }
            final conversationStore = GetIt.instance<ConversationStore>();
            List<ConversationModel> list = await conversationStore
                .getListConversation(event['token'], event['userId']);
            NotificationHelper.showMessengerNotification(list.last);
          },
        );
}

class FetchNotification extends BgEvent {
  FetchNotification()
      : super(
          event: 'fetchNotification',
          onData: (event) {
            print('fetchNotification');
            print(event);
          },
        );
}

// endregion