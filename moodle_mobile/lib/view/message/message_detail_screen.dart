// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/view/common/custom_text_field.dart';
import 'package:moodle_mobile/view/common/custom_text_field_message_detail.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:moodle_mobile/store/conversation/conversation_store.dart';
import 'package:moodle_mobile/store/conversation_detail/conversation_detail_store.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/data/repository.dart';

class MessageDetailScreen extends StatefulWidget {
  MessageDetailScreen(
      {Key? key, required this.conversationId, required this.userFrom})
      : super(key: key);
  final int conversationId;
  final String userFrom;

  @override
  State<MessageDetailScreen> createState() => _MessageDetailScreenState();
}

class _MessageDetailScreenState extends State<MessageDetailScreen> {
  late UserStore _userStore;
  late ConversationDetailStore _conversationDetailStore;
  late ConversationStore _conversationStore;
  late Timer _refreshTimer;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _userStore = GetIt.instance<UserStore>();
    _conversationStore = GetIt.instance<ConversationStore>();
    _conversationDetailStore =
        ConversationDetailStore(GetIt.instance<Repository>());
    _conversationDetailStore.getListMessage(
        _userStore.user.token, _userStore.user.id, widget.conversationId);

    // Update message list
    _refreshTimer = Timer.periodic(
        const Duration(seconds: 5),
        (t) => _conversationDetailStore.getListMessage(
            _userStore.user.token, _userStore.user.id, widget.conversationId));
  }

  @override
  void dispose() {
    _refreshTimer.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: BackButton(color: Colors.white),
        title: Text(
          widget.userFrom,
          style: TextStyle(color: Colors.white),
        ),
        //const Text("Messenger", style: TextStyle(color: Colors.white))
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Observer(builder: (_) {
          return Column(
            children: [
              Expanded(
                flex: 10,
                child: ListView.builder(
                  reverse: true,
                  controller: _scrollController,
                  itemCount: _conversationDetailStore.listMessages.length,
                  itemBuilder: (_, int index) {
                    return _conversationDetailStore
                                .listMessages[index].userIdFrom ==
                            _userStore.user.id
                        ? CustomTextFieldRight(
                            messageText: _conversationDetailStore
                                .listMessages[index].text)
                        : CustomTextFieldLeft(
                            messageText: _conversationDetailStore
                                .listMessages[index].text);
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(Dimens.default_padding),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                          child: CustomTextFieldWidget(
                        controller: _textEditingController,
                        hintText: "Enter message",
                        borderRadius: Dimens.default_border_radius * 2,
                      )),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: CircleBorder(),
                          side: BorderSide(color: Colors.white),
                        ),
                        onPressed: () async {
                          await _conversationDetailStore.sentMessage(
                              _userStore.user.token,
                              widget.conversationId,
                              _textEditingController.text);

                          _textEditingController.clear();

                          _scrollController.animateTo(
                            0,
                            duration: Duration(seconds: 2),
                            curve: Curves.fastOutSlowIn,
                          );
                        },
                        child: Icon(Icons.send, size: 30),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}