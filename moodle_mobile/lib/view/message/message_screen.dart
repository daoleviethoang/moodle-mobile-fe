import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/view/common/custom_button_short.dart';
import 'package:moodle_mobile/view/common/slidable_tile.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:moodle_mobile/data/repository.dart';
import 'package:moodle_mobile/view/message/message_detail_screen.dart';
import 'package:moodle_mobile/store/conversation/conversation_store.dart';
import 'package:moodle_mobile/store/conversation_detail/conversation_detail_store.dart';
import 'package:moodle_mobile/store/user/user_store.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  // Tai day khai bao cac store ma ta se su dung
  late ConversationStore _conversationStore;
  late UserStore _userStore;
  late ConversationDetailStore _conversationDetailStore;
  late Timer _refreshTimer;

  @override
  void initState() {
    super.initState();

    // Store ta da khoi tao trong service_locator
    // Tai day ta chi can goi store do ra de su dung
    // Ta chi goi store trong cac ham initState hoac didChangeDependenices
    // Cach thu goi store nhu sau
    _conversationStore = GetIt.instance<ConversationStore>();
    _userStore = GetIt.instance<UserStore>();
    _conversationDetailStore =
        ConversationDetailStore(GetIt.instance<Repository>());

    // Sau khi goi store thanh cong, ta se thu goi
    // action get list conversation info va xem ket qua
    // Tai day can truyen vao token va user Id, 2 gia tri nay duoc luu tru
    // trong user store, nen ta cung phai goi user store ra
    _conversationStore.getListConversation(
        _userStore.user.token, _userStore.user.id);

    // Nhu vay la hoan tat

    // Update message list
    _refreshTimer = Timer.periodic(
        const Duration(seconds: 5),
        (t) => _conversationStore.getListConversation(
            _userStore.user.token, _userStore.user.id));
  }

  @override
  void dispose() {
    _refreshTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(width: 12),
                Expanded(
                  child: CustomButtonShort(
                      text: "Message",
                      textColor: MoodleColors.blue,
                      bgColor: MoodleColors.brightGray,
                      blurRadius: 3,
                      onPressed: () {}),
                ),
                Container(width: 12),
                Expanded(
                  child: CustomButtonShort(
                      text: "Contact",
                      textColor: Colors.black,
                      bgColor: Colors.white,
                      blurRadius: 3,
                      onPressed: () {}),
                ),
                Container(width: 12),
              ],
            ),
          ),
          Observer(builder: (_) {
            return Expanded(
                child: _conversationStore.listConversation.isEmpty
                    ? const Center(child: CircularProgressIndicator.adaptive())
                    : ListView.builder(
                        padding: EdgeInsets.all(Dimens.default_padding),
                        itemCount: _conversationStore.listConversation.length,
                        itemBuilder: (_, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                top: Dimens.default_padding),
                            child: Observer(builder: (_) {
                              return SlidableTile(
                                  isNotification: !_conversationStore
                                      .listConversation[index].isMuted,
                                  nameInfo: _conversationStore
                                      .listConversation[index]
                                      .members[0]
                                      .fullname,
                                  message: _conversationStore
                                      .listConversation[index].message,
                                  onDeletePress: () {
                                    _conversationStore.deleteConversation(
                                        _userStore.user.token,
                                        _userStore.user.id,
                                        _conversationStore
                                            .listConversation[index].id);
                                  },
                                  onAlarmPress: () {
                                    _conversationStore
                                            .listConversation[index].isMuted
                                        ? _conversationStore
                                            .unmuteOneConversation(
                                                _userStore.user.token,
                                                _userStore.user.id,
                                                _conversationStore
                                                    .listConversation[index].id)
                                        : _conversationStore
                                            .muteOneConversation(
                                                _userStore.user.token,
                                                _userStore.user.id,
                                                _conversationStore
                                                    .listConversation[index]
                                                    .id);
                                  },
                                  onMessDetailPress: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MessageDetailScreen(
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
                        }));
          })
        ],
      ),
    );
  }

  void onSearchContact() {
    print("Search is on");
  }
}