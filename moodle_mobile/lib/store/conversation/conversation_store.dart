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
  List<ConversationModel> listConversation = [];

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
      listConversation = await _repository.getConversationInfo(token, userId);

      // Nhu vay la da goi du lieu tu backend ve va gan vao
      // bien ma ta dang can quan sat thanh cong
      // Bay gio ta chi can goi action tu cac view
      // Vay da lay du lieu thanh cong.
      print(listConversation.length);

      // Xem ky lai flow nay, sau khi da hieu het thi chi
      // can lay data tu day ma render ra UI thoi
      isLoading = false;
    } catch (e) {
      // In loi neu trong qua trinh xu ly co loi xay ra
      print("Get conversations error: " + e.toString());
    }
  }
}
