import 'package:moodle_mobile/data/network/apis/conversation/conversation_api.dart';
import 'package:moodle_mobile/data/network/apis/user/user_api.dart';
import 'package:moodle_mobile/models/conversation/conversation.dart';
import 'package:moodle_mobile/models/user.dart';

class Repository {
  final UserApi _userApi;
  final ConversationApi _conversationApi;

  // Constructor
  Repository(this._userApi, this._conversationApi);

  // User Login
  Future<String> login(String username, String password, String service) =>
      _userApi.login(username, password, service);

  Future<UserModel> getUserInfo(String token, String username) =>
      _userApi.getUserInfo(token, username);

  Future<List<ConversationModel>> getConversationInfo(
          String token, int userid) =>
      _conversationApi.getConversationInfo(token, userid);

  Future<List> muteOneConversation(
          String token, int userId, int conversationId) =>
      _conversationApi.muteOneConversation(token, userId, conversationId);
}
