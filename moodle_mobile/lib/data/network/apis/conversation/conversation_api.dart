import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/dio_client.dart';
import 'package:moodle_mobile/models/conversation/conversation.dart';
import 'package:moodle_mobile/models/conversation/conversation_member.dart';
import 'package:moodle_mobile/models/conversation/conversation_message.dart';

class ConversationApi {
  final DioClient _dioClient;

  ConversationApi(this._dioClient);
  Future<List<ConversationModel>> getConversationInfo(
      String token, int userid) async {
    try {
      final res =
          await _dioClient.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': 'core_message_get_conversations',
        'moodlewsrestformat': 'json',
        'userid': userid
      });

      // Handle Error
      // if (res['message']) equals to if message exist
      if (res['message'] != null) {
        throw Exception(res['message']);
      }

      List<ConversationModel> listConversation = [];
      for (var i = 0; i < res['conversations'].length; i++) {
        List<ConversationMemberModel> listConversationMember = [];

        for (var j = 0; j < res['conversations'][i]['members'].length; j++) {
          listConversationMember.add(ConversationMemberModel(
              id: res['conversations'][i]['members'][j]['id'],
              fullname: res['conversations'][i]['members'][j]['fullname'],
              profileImageURL: res['conversations'][i]['members'][j]
                  ['profileimageurl'],
              isOnline:
                  res['conversations'][i]['members'][j]['isonline'] == null
                      ? false
                      : true,
              isBlocked: res['conversations'][i]['members'][j]['isblocked'],
              showOnLineStatus: res['conversations'][i]['members'][j]
                  ['showonlinestatus']));
        }

        listConversation.add(ConversationModel(
            id: res['conversations'][i]['id'],
            memberCount: res['conversations'][i]['membercount'],
            isMuted: res['conversations'][i]['ismuted'],
            members: listConversationMember,
            isRead: res['conversations'][i]['isread'],
            message: res['conversations'][i]['messages'].length > 0
                ? ConversationMessageModel(
                    id: res['conversations'][i]['messages'][0]['id'],
                    userIdFrom: res['conversations'][i]['messages'][0]
                        ['useridfrom'],
                    text: res['conversations'][i]['messages'][0]['text'],
                    timeCreated: res['conversations'][i]['messages'][0]
                        ['timecreated'])
                : null));
      }

      return listConversation;
    } catch (e) {
      rethrow;
    }
  }

  Future<List> muteOneConversation(
      String token, int userId, int conversationId) async {
    try {
      final res =
          await _dioClient.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': 'core_message_mute_conversations',
        'moodlewsrestformat': 'json',
        'conversationids[0]': conversationId,
        'userid': userId,
      });

      return res;
    } catch (e) {
      print("API error: " + e.toString());
      rethrow;
    }
  }

  Future<List> unmuteOneConversation(
      String token, int userId, int conversationId) async {
    try {
      final res =
          await _dioClient.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': 'core_message_unmute_conversations',
        'moodlewsrestformat': 'json',
        'conversationids[0]': conversationId,
        'userid': userId,
      });

      return res;
    } catch (e) {
      print("API error: " + e.toString());
      rethrow;
    }
  }

  Future<List> deleteConversation(
      String token, int userId, int conversationId) async {
    try {
      final res =
          await _dioClient.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': 'core_message_delete_conversations_by_id',
        'moodlewsrestformat': 'json',
        'conversationids[0]': conversationId,
        'userid': userId,
      });

      return res;
    } catch (e) {
      print("API error: " + e.toString());
      rethrow;
    }
  }

  Future<List<ConversationMessageModel>> detailConversation(String token,
      int userId, int conversationId, int newest, int limit) async {
    try {
      final res =
          await _dioClient.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': 'core_message_get_conversation_messages',
        'moodlewsrestformat': 'json',
        'currentuserid': userId,
        'convid': conversationId,
        'newest': newest,
        'limitnum': limit
      });

      List<ConversationMessageModel> listMessageDetail = [];
      for (int i = 0; i < res['messages'].length; i++) {
        listMessageDetail.add(ConversationMessageModel(
            id: res['messages'][i]['id'],
            userIdFrom: res['messages'][i]['useridfrom'],
            text: res['messages'][i]['text'],
            timeCreated: res['messages'][i]['timecreated']));
      }

      return listMessageDetail;
    } catch (e) {
      print("API error: " + e.toString());
      rethrow;
    }
  }

  Future<ConversationMessageModel> sentMessage(
      String token, int conversationId, String text) async {
    try {
      final res =
          await _dioClient.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': 'core_message_send_messages_to_conversation',
        'moodlewsrestformat': 'json',
        'messages[0][text]': text,
        'conversationid': conversationId,
        'messages[0][textformat]': 0
      });

      return ConversationMessageModel(
          id: res[0]['id'],
          userIdFrom: res[0]['useridfrom'],
          text: text,
          timeCreated: res[0]['timecreated']);
    } catch (e) {
      print("Sent message Api error" + e.toString());
      rethrow;
    }
  }
}
