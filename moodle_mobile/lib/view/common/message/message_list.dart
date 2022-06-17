import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:moodle_mobile/constants/vars.dart';
import 'package:moodle_mobile/data/repository.dart';
import 'package:moodle_mobile/store/conversation/conversation_store.dart';
import 'package:moodle_mobile/store/conversation_detail/conversation_detail_store.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/common/slidable_tile.dart';
import 'package:moodle_mobile/view/message/message_detail_screen.dart';

class MessageList extends StatefulWidget {
  const MessageList({Key? key}) : super(key: key);

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  late ConversationStore _conversationStore;
  late UserStore _userStore;
  late Timer _refreshTimer;

  @override
  void initState() {
    super.initState();

    _conversationStore = GetIt.instance<ConversationStore>();
    _userStore = GetIt.instance<UserStore>();

    getConversations();

    // Update message list
    _refreshTimer =
        Timer.periodic(Vars.refreshInterval, (t) => getConversations());
  }

  Future getConversations() async => _conversationStore.getListConversation(
      _userStore.user.token, _userStore.user.id);

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      var cons = _conversationStore.listConversation;
      return Expanded(
        child: RefreshIndicator(
          onRefresh: () => getConversations(),
          child: ListView(
            padding: const EdgeInsets.all(Dimens.default_padding),
            children: [
              Container(height: Dimens.default_padding),
              if (cons.isEmpty)
                Opacity(
                  opacity: .5,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.nothing_yet,
                    ),
                  ),
                ),
              ...List.generate(cons.length, (index) {
                return Observer(builder: (_) {
                  return SlidableTile(
                      isNotification: !cons[index].isMuted,
                      nameInfo: cons[index].members[0].fullname,
                      message: cons[index].message,
                      onDeletePress: () {
                        _conversationStore.deleteConversation(
                            _userStore.user.token,
                            _userStore.user.id,
                            cons[index].id);
                      },
                      onAlarmPress: () {
                        cons[index].isMuted
                            ? _conversationStore.unmuteOneConversation(
                                _userStore.user.token,
                                _userStore.user.id,
                                cons[index].id)
                            : _conversationStore.muteOneConversation(
                                _userStore.user.token,
                                _userStore.user.id,
                                cons[index].id);
                      },
                      onMessDetailPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MessageDetailScreen(
                              conversationId: cons[index].id,
                              userFrom: cons[index].members[0].fullname,
                            ),
                          ),
                        );
                      });
                });
              })
            ],
          ),
        ),
      );
    });
  }
}
