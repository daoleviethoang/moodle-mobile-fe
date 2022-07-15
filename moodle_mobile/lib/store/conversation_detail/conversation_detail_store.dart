import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:moodle_mobile/data/repository.dart';
import 'package:moodle_mobile/models/conversation/conversation_message.dart';

part 'conversation_detail_store.g.dart';

class ConversationDetailStore = _ConversationDetailStore
    with _$ConversationDetailStore;

abstract class _ConversationDetailStore with Store {
  final Repository _repository;

  _ConversationDetailStore(this._repository, this.conversationId);

  @observable
  ObservableList<ConversationMessageModel> listMessages = ObservableList();

  @observable
  int? conversationId;

  @action
  Future getListMessage(String token, int userId, int conversationId) async {
    try {
      listMessages = ObservableList.of(await _repository.detailConversation(
          token, userId, conversationId, 0, 50));
      listMessages = ObservableList.of(listMessages.reversed);

      if (kDebugMode) {
        print(
            "Get list message success: ${listMessages.length} with user ${userId}");
      }
    } catch (e) {
      if (kDebugMode) print("Get message error: $e");
    }
  }

  @action
  Future markMessageRead(String token, int userId, int conversationId) async {
    try {
      await _repository.markMessageRead(token, userId, conversationId);
    } catch (e) {
      if (kDebugMode) print("Get message error: $e");
    }
  }

  @action
  Future sentMessage(String token, int conversationId, String text) async {
    try {
      ConversationMessageModel message =
          await _repository.sentMessage(token, conversationId, text);
    } catch (e) {
      if (kDebugMode) {
        print("Sent message error: $e");
      }
    }
  }

  @action
  Future sentMessageWithoutConversationId(
      String token, String text, int userId, int userIdFrom) async {
    try {
      ConversationMessageModel message = await _repository
          .sentMessageWithoutConversationId(token, text, userId, userIdFrom);

      conversationId = message.conversationId;
    } catch (e) {
      if (kDebugMode) {
        print("Sent message error: $e");
      }
    }
  }
}