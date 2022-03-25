import 'package:mobx/mobx.dart';
import 'package:moodle_mobile/data/repository.dart';
import 'package:moodle_mobile/models/conversation/conversation_message.dart';

part 'conversation_detail_store.g.dart';

class ConversationDetailStore = _ConversationDetailStore
    with _$ConversationDetailStore;

abstract class _ConversationDetailStore with Store {
  final Repository _repository;
  _ConversationDetailStore(this._repository);

  @observable
  ObservableList<ConversationMessageModel> listMessages = ObservableList();

  @action
  Future getListMessage(String token, int userId, int conversationId) async {
    try {
      listMessages = ObservableList.of(await _repository.detailConversation(
          token, userId, conversationId, 0, 50));
      listMessages = ObservableList.of(listMessages.reversed);

      print("Get list message success: " + listMessages.length.toString());
    } catch (e) {
      print("Get message error: " + e.toString());
    }
  }

  @action
  Future sentMessage(String token, int conversationId, String text) async {
    try {
      ConversationMessageModel message =
          await _repository.sentMessage(token, conversationId, text);
      listMessages.insert(0, message);
    } catch (e) {
      print("Sent message error" + e.toString());
    }
  }
}
