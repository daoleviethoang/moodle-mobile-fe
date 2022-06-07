import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
  late ConversationDetailStore _conversationDetailStore;
  late Timer _refreshTimer;

  @override
  void initState() {
    super.initState();

    _conversationStore = GetIt.instance<ConversationStore>();
    _userStore = GetIt.instance<UserStore>();
    _conversationDetailStore =
        ConversationDetailStore(GetIt.instance<Repository>());

    _conversationStore.getListConversation(
        _userStore.user.token, _userStore.user.id);

    // Update message list
    _refreshTimer = Timer.periodic(
        Vars.refreshInterval,
        (t) => _conversationStore.getListConversation(
            _userStore.user.token, _userStore.user.id));
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return Expanded(
        child: AnimatedOpacity(
          opacity: _conversationStore.listConversation.isEmpty ? 0 : 1,
          duration: const Duration(milliseconds: 300),
          child: ListView.builder(
              padding: EdgeInsets.all(Dimens.default_padding),
              itemCount: _conversationStore.listConversation.length,
              itemBuilder: (_, int index) {
                return Padding(
                  padding: const EdgeInsets.only(top: Dimens.default_padding),
                  child: Observer(builder: (_) {
                    return SlidableTile(
                        isNotification:
                            !_conversationStore.listConversation[index].isMuted,
                        nameInfo: _conversationStore
                            .listConversation[index].members[0].fullname,
                        message:
                            _conversationStore.listConversation[index].message,
                        onDeletePress: () {
                          _conversationStore.deleteConversation(
                              _userStore.user.token,
                              _userStore.user.id,
                              _conversationStore.listConversation[index].id);
                        },
                        onAlarmPress: () {
                          _conversationStore.listConversation[index].isMuted
                              ? _conversationStore.unmuteOneConversation(
                                  _userStore.user.token,
                                  _userStore.user.id,
                                  _conversationStore.listConversation[index].id)
                              : _conversationStore.muteOneConversation(
                                  _userStore.user.token,
                                  _userStore.user.id,
                                  _conversationStore
                                      .listConversation[index].id);
                        },
                        onMessDetailPress: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MessageDetailScreen(
                                conversationId: _conversationStore
                                    .listConversation[index].id,
                                userFrom: _conversationStore
                                    .listConversation[index]
                                    .members[0]
                                    .fullname,
                              ),
                            ),
                          );
                        });
                  }),
                );
              }),
        ),
      );
    });
  }
}