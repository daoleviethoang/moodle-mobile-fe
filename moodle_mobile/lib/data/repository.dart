import 'package:moodle_mobile/data/network/apis/contact/contact_message.dart';
import 'package:moodle_mobile/data/network/apis/conversation/conversation_api.dart';
import 'package:moodle_mobile/data/network/apis/course/course_participants.dart';
import 'package:moodle_mobile/data/network/apis/user/user_api.dart';
import 'package:moodle_mobile/data/shared_reference/shared_preference_helper.dart';
import 'package:moodle_mobile/models/conversation/conversation.dart';
import 'package:moodle_mobile/models/conversation/conversation_member.dart';
import 'package:moodle_mobile/models/conversation/conversation_message.dart';
import 'package:moodle_mobile/models/course/course_participants.dart';
import 'package:moodle_mobile/models/user.dart';

class Repository {
  final UserApi _userApi;
  final ConversationApi _conversationApi;
  final SharedPreferenceHelper _sharedPreferencesHelper;
  final CourseParticipants _courseParticipants;
  final ContactOfMessage _contactOfMessage;
  // Constructor
  Repository(
      this._userApi,
      this._conversationApi,
      this._sharedPreferencesHelper,
      this._courseParticipants,
      this._contactOfMessage);

  // AuthToken
  String? get authToken {
    return _sharedPreferencesHelper.authToken;
  }

  Future<bool> saveAuthToken(String authToken) {
    return _sharedPreferencesHelper.saveAuthToken(authToken);
  }

  Future<bool> removeAuthToken() async {
    return _sharedPreferencesHelper.removeAuthToken();
  }

  // Get and Save Username
  String? get username {
    return _sharedPreferencesHelper.username;
  }

  Future<bool> saveUsername(String username) {
    return _sharedPreferencesHelper.saveUsername(username);
  }

  String? get baseUrl {
    return _sharedPreferencesHelper.baseUrl;
  }

  Future<bool> saveBaseUrl(String baseUrl) {
    return _sharedPreferencesHelper.saveBaseUrl(baseUrl);
  }

  String? get lastUpdated {
    return _sharedPreferencesHelper.lastUpdated;
  }

  Future<bool> saveLastUpdated(String lastUpdated) {
    return _sharedPreferencesHelper.saveLastUpdated(lastUpdated);
  }

  // User Login
  Future<String> login(String username, String password, String service) =>
      _userApi.login(username, password, service);

  Future<UserModel> getUserInfo(String token, String username) {
    return _userApi.getUserInfo(token, username);
  }

  Future<List<ConversationModel>> getConversationInfo(
          String token, int userid) =>
      _conversationApi.getConversationInfo(token, userid);

  Future<List> muteOneConversation(
          String token, int userId, int conversationId) =>
      _conversationApi.muteOneConversation(token, userId, conversationId);

  Future<List> unmuteOneConversation(
          String token, int userId, int conversationId) =>
      _conversationApi.unmuteOneConversation(token, userId, conversationId);

  Future<List> deleteConversation(
          String token, int userId, int conversationId) =>
      _conversationApi.deleteConversation(token, userId, conversationId);

  Future<List<ConversationMessageModel>> detailConversation(String token,
          int userId, int conversationId, int newest, int limit) =>
      _conversationApi.detailConversation(
          token, userId, conversationId, newest, limit);
  Future markMessageRead(String token, int userId, int conversationId) =>
      _conversationApi.markMessageRead(token, userId, conversationId);
  Future sentMessage(String token, int conversationId, String text) =>
      _conversationApi.sentMessage(token, conversationId, text);
  Future sentMessageWithoutConversationId(
          String token, String text, int userId, int userIdFrom) =>
      _conversationApi.sentMessageWithoutConversationId(
          token, text, userId, userIdFrom);
  Future<List<CourseParticipantsModel>> courseParticipant(token, courseId) =>
      _courseParticipants.getParticipantInCourse(token, courseId);
  Future<List<ConversationMemberModel>> listcontactUser(token, userId) =>
      _contactOfMessage.getUserContact(token, userId);
  Future getConversationIdByUserId(token, userId, otherUserId) =>
      _conversationApi.getIdConversationByUserId(token, userId, otherUserId);
}