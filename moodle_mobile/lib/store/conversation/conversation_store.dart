import 'package:mobx/mobx.dart';
import 'package:moodle_mobile/data/repository.dart';
import 'package:moodle_mobile/models/conversation/conversation.dart';

// Include generated file
part 'conversation_store.g.dart';

class ConversationStore = _ConversationStore with _$ConversationStore;

// Conversation store dung de luu tru,
// quan sat su thay doi cua cac conversation cua 1 user
// De thuc hien dieu do thi can:
// Oservable 1 bien List<ConversationModel>
//
// Lay du lieu tu dau ra ??
// Goi tu api ra, lam sao de goi API, phai khoi tao repository
// tu constructore
abstract class _ConversationStore with Store {
  // Khoi tao 1 bien repository, bien repository la
  // trung gian dung de goi cac API lay du lieu tu backend
  final Repository _repository;

  // _ConversationStore day la ham constructor dung de
  // khoi tao class, o day se truyen repository tu ben ngoai vao
  // class conversation store se duoc khoi tao trong file
  // service_locator.dart
  _ConversationStore(this._repository);

  // ConversationStore quan sat su thay doi cua
  // danh sach conversation nen ta se khoi tao
  // 1 list conversation de quan sat
  // Khi khoi tao 1 bien observable can gan gia tri mac
  // dinh cho no nen ta gan = []
  @observable
  ObservableList<ConversationModel> listConversation = ObservableList();

  @observable
  bool isLoading = false;

  // Tao danh sach cac action de tuong tac voi cac bien
  // observable, tai day don gian nhat la can action
  // de lay du lieu tu backend va gan vao bien nay
  // Vi lay du lieu tu backend nen goi ham future
  // ham future thi can async await de lay du lieu
  @action
  Future getListConversation(String token, int userId) async {
    try {
      isLoading = true;

      // Goi ham lay danh sach conversation tu repository
      // Ham tra ve List<ConversationModel> se giong kieu
      // du lieu cua bien listConversation ==> ta gan du lieu
      // vao bien listConversation
      listConversation = ObservableList.of(
          await _repository.getConversationInfo(token, userId));

      isLoading = false;
    } catch (e) {
      // In loi neu trong qua trinh xu ly co loi xay ra
      print("Get conversations error: " + e.toString());
    }
  }

  @action
  Future muteOneConversation(
      String token, int userId, int conversationId) async {
    try {
      List mute =
          await _repository.muteOneConversation(token, userId, conversationId);

      // If mute.isEmpty is if mute success
      if (mute.isEmpty) {
        // listConversation la 1 cai list, moi phan tu la 1 object
        // observer chi quan sat duoc su thay doi cua list (them 1 phan tu, xoa 1 phan tu)
        // thay the 1 phan tu
        // observer khong the quan sat duoc su thay doi cua 1 property thuoc 1 phan tu
        listConversation = ObservableList.of(List.from(listConversation));
        for (int i = 0; i < listConversation.length; i++) {
          if (listConversation[i].id == conversationId) {
            listConversation[i].isMuted = true;
            return;
          }
        }
      }
    } catch (e) {
      print("Mute conversation error: " + e.toString());
    }
  }

  @action
  Future unmuteOneConversation(
      String token, int userId, int conversationId) async {
    try {
      List mute = await _repository.unmuteOneConversation(
          token, userId, conversationId);

      if (mute.isEmpty) {
        listConversation = ObservableList.of(List.from(listConversation));
        for (int i = 0; i < listConversation.length; i++) {
          if (listConversation[i].id == conversationId) {
            listConversation[i].isMuted = false;
            return;
          }
        }
      }
    } catch (e) {
      print("Mute conversation error: " + e.toString());
    }
  }

  @action
  Future deleteConversation(
      String token, int userId, int conversationId) async {
    try {
      List deleteConversation =
          await _repository.deleteConversation(token, userId, conversationId);

      if (deleteConversation.isEmpty) {
        listConversation.removeWhere((element) => element.id == conversationId);
      }
    } catch (e) {
      print("Delete conversation error: " + e.toString());
    }
  }
}
