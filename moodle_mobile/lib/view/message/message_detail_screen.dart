import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/constants/vars.dart';
import 'package:moodle_mobile/data/firebase/firestore/imgur_service.dart';
import 'package:moodle_mobile/view/common/custom_text_field.dart';
import 'package:moodle_mobile/view/common/custom_text_field_message_detail.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:moodle_mobile/store/conversation/conversation_store.dart';
import 'package:moodle_mobile/store/conversation_detail/conversation_detail_store.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/data/repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MessageDetailScreen extends StatefulWidget {
  const MessageDetailScreen(
      {Key? key,
      required this.conversationId,
      required this.userFrom,
      this.userFromId})
      : super(key: key);
  final int? conversationId;
  final String userFrom;
  final int? userFromId;

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
    _conversationDetailStore = ConversationDetailStore(
        GetIt.instance<Repository>(), widget.conversationId);
    getListMessage();

    // Update message list
    _refreshTimer =
        Timer.periodic(Vars.refreshInterval, (t) async => getListMessage());

    // Mark messages as read
    _conversationDetailStore.markMessageRead(_userStore.user.token,
        _userStore.user.id, _conversationDetailStore.conversationId!);
  }

  Future getListMessage() async {
    if (_conversationDetailStore.conversationId != null) {
      await _conversationDetailStore.getListMessage(_userStore.user.token,
          _userStore.user.id, _conversationDetailStore.conversationId!);
    }
  }

  @override
  void dispose() {
    _refreshTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: const BackButton(color: Colors.white),
        title: Text(
          widget.userFrom,
          style: const TextStyle(color: Colors.white),
        ),
        //const Text("Messenger", style: TextStyle(color: Colors.white))
        centerTitle: false,
      ),
      body: Observer(builder: (_) {
        return Column(
          children: [
            Expanded(
              flex: 10,
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                reverse: true,
                controller: _scrollController,
                itemCount: _conversationDetailStore.listMessages.length,
                itemBuilder: (_, int index) {
                  return _conversationDetailStore
                              .listMessages[index].userIdFrom ==
                          _userStore.user.id
                      ? CustomTextFieldRight(
                          messageText:
                              _conversationDetailStore.listMessages[index].text)
                      : CustomTextFieldLeft(
                          messageText: _conversationDetailStore
                              .listMessages[index].text);
                },
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 70, maxHeight: 150),
              child: Padding(
                padding: const EdgeInsets.all(Dimens.default_padding),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextFieldWidget(
                        controller: _textEditingController,
                        hintText: AppLocalizations.of(context)!.enter_message,
                        borderRadius: Dimens.default_border_radius * 2,
                        maxLines: null,
                        haveLabel: false,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimens.default_padding),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.all(8),
                          shape: const CircleBorder(),
                        ),
                        onPressed: _onImagePressed,
                        child: const Icon(Icons.image_rounded, size: 30),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: const EdgeInsets.all(8),
                        shape: const CircleBorder(),
                      ),
                      onPressed: _onSendPressed,
                      child: const Icon(Icons.send_rounded, size: 30),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      }),
    );
  }

  void _onImagePressed() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null) return;
    final path = result.files[0].path;
    if (path == null) return;
    final compressed = await _compressFile(path);
    final base64 = base64Encode(compressed.toList());
    final url = await ImgurService.uploadImage(base64);
    if (url.isEmpty) return;
    _textEditingController.text = '<img src="$url" alt="image"/>';
    _onSendPressed();
  }

  Future<Uint8List> _compressFile(String path) async {
    final file = File(path);
    final result = await FlutterImageCompress.compressWithFile(
      path,
      format: CompressFormat.jpeg,
      minHeight: 1920,
      minWidth: 1080,
      quality: 50,
    ) ?? Uint8List(0);
    if (kDebugMode) {
      print('Compressed ${await file.length()} to ${result.length}');
    }
    return result;
  }

  void _onSendPressed() async {
    if (_textEditingController.text.isEmpty) {
      return;
    }

    var newText = _textEditingController.text;

    _textEditingController.clear();

    if (_conversationDetailStore.conversationId != null) {
      await _conversationDetailStore.sentMessage(
          _userStore.user.token, widget.conversationId!, newText);
    } else {
      await _conversationDetailStore.sentMessageWithoutConversationId(
          _userStore.user.token,
          newText,
          _userStore.user.id,
          widget.userFromId!);
      getListMessage();
    }

    _scrollController.animateTo(
      0,
      duration: const Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }
}