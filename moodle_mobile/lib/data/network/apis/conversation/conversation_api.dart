import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/constants/wsfunction_constants.dart';
import 'package:moodle_mobile/data/network/dio_client.dart';
import 'package:moodle_mobile/models/conversation/conversation.dart';
import 'package:moodle_mobile/models/conversation/conversation_member.dart';
import 'package:moodle_mobile/models/conversation/conversation_message.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';

class ConversationApi {
  final DioClient _dioClient;

  ConversationApi(this._dioClient);
  Future<List<ConversationModel>> getConversationInfo(
      String token, int userid) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.CORE_MESSAGE_GET_CONVERSATIONS,
        'moodlewsrestformat': 'json',
        'userid': userid
      });
      // Handle Error
      // if (res['message']) equals to if message exist
      if (res.data['message'] != null) {
        throw Exception(res.data['message']);
      }

      List<ConversationModel> listConversation = [];
      for (var i = 0; i < res.data['conversations'].length; i++) {
        List<ConversationMemberModel> listConversationMember = [];

        for (var j = 0;
            j < res.data['conversations'][i]['members'].length;
            j++) {
          listConversationMember.add(ConversationMemberModel(
              id: res.data['conversations'][i]['members'][j]['id'],
              fullname: res.data['conversations'][i]['members'][j]['fullname'],
              profileImageURL: res.data['conversations'][i]['members'][j]
                  ['profileimageurl'],
              isOnline:
                  res.data['conversations'][i]['members'][j]['isonline'] == null
                      ? false
                      : true,
              isBlocked: res.data['conversations'][i]['members'][j]
                  ['isblocked'],
              showOnLineStatus: res.data['conversations'][i]['members'][j]
                  ['showonlinestatus']));
        }

        listConversation.add(ConversationModel(
            id: res.data['conversations'][i]['id'],
            memberCount: res.data['conversations'][i]['membercount'],
            isMuted: res.data['conversations'][i]['ismuted'],
            members: listConversationMember,
            isRead: res.data['conversations'][i]['isread'],
            message: res.data['conversations'][i]['messages'].length > 0
                ? ConversationMessageModel(
                    id: res.data['conversations'][i]['messages'][0]['id'],
                    userIdFrom: res.data['conversations'][i]['messages'][0]
                        ['useridfrom'],
                    text: res.data['conversations'][i]['messages'][0]['text'],
                    timeCreated: res.data['conversations'][i]['messages'][0]
                        ['timecreated'])
                : null));
      }

      return listConversation;
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
      rethrow;
    }
  }

  Future<List> muteOneConversation(
      String token, int userId, int conversationId) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.CORE_MESSAGE_MUTE_CONVERSATIONS,
        'moodlewsrestformat': 'json',
        'conversationids[0]': conversationId,
        'userid': userId,
      });
      if (kDebugMode) {
        print("as as saaasss");
        print(res);
      }

      return res.data;
    } catch (e) {
      if (kDebugMode) {
        print("API error: $e");
      }
      rethrow;
    }
  }

  Future<List> unmuteOneConversation(
      String token, int userId, int conversationId) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.CORE_MESSAGE_UNMUTE_CONVERSATIONS,
        'moodlewsrestformat': 'json',
        'conversationids[0]': conversationId,
        'userid': userId,
      });

      return res.data;
    } catch (e) {
      if (kDebugMode) {
        print("API error: $e");
      }
      rethrow;
    }
  }

  Future<List> deleteConversation(
      String token, int userId, int conversationId) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.CORE_MESSAGE_DELETE_CONVERSATION_BY_ID,
        'moodlewsrestformat': 'json',
        'conversationids[0]': conversationId,
        'userid': userId,
      });

      return res.data;
    } catch (e) {
      if (kDebugMode) {
        print("API error: $e");
      }
      rethrow;
    }
  }

  Future<List<ConversationMessageModel>> detailConversation(String token,
      int userId, int conversationId, int newest, int limit) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.CORE_MESSAGE_GET_CONVERSATION_MESSAGES,
        'moodlewsrestformat': 'json',
        'currentuserid': userId,
        'convid': conversationId,
        'newest': newest,
        'limitnum': limit
      });

      List<ConversationMessageModel> listMessageDetail = [];
      for (int i = 0; i < res.data['messages'].length; i++) {
        listMessageDetail.add(ConversationMessageModel(
            id: res.data['messages'][i]['id'],
            userIdFrom: res.data['messages'][i]['useridfrom'],
            text: res.data['messages'][i]['text'],
            timeCreated: res.data['messages'][i]['timecreated']));
      }

      return listMessageDetail;
    } catch (e) {
      if (kDebugMode) {
        print("API error: $e");
      }
      rethrow;
    }
  }

  Future<void> markMessageRead(
      String token, int userId, int conversationId) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.MARK_MESSAGES_AS_READ,
        'moodlewsrestformat': 'json',
        'userid': userId,
        'conversationid': conversationId,
      });

    } catch (e) {
      if (kDebugMode) {
        print("Mark message read Api error: $e");
      }
      rethrow;
    }
  }

  Future<ConversationMessageModel> sentMessage(
      String token, int conversationId, String text) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.CORE_MESSAGE_SEND_MESSAGES_TO_CONVERSATION,
        'moodlewsrestformat': 'json',
        'messages[0][text]': text,
        'conversationid': conversationId,
        'messages[0][textformat]': 1
      });

      return ConversationMessageModel(
          id: res.data[0]['id'],
          userIdFrom: res.data[0]['useridfrom'],
          text: text,
          timeCreated: res.data[0]['timecreated']);
    } catch (e) {
      if (kDebugMode) {
        print("Sent message Api error: $e");
      }
      rethrow;
    }
  }

  Future getIdConversationByUserId(
      String token, int userId, int otherUserId) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.CORE_MESSAGE_GET_CONVERSATION_BETWEEN_USER,
        'moodlewsrestformat': 'json',
        'userid': userId,
        'otheruserid': otherUserId,
        'includecontactrequests': 1,
        'includeprivacyinfo': 1
      });
      if (res.data['errorcode'] != null) {
        print(res.data['errorcode']);
        return;
      }
      return res.data['id'];
    } catch (e) {
      if (kDebugMode) {
        print("Sent message Api error: $e");
      }
      rethrow;
    }
  }

  Future sentMessageWithoutConversationId(
      String token, String text, int userId, int userIdFrom) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction':
            Wsfunction.CORE_MESSAGE_SEND_MESSAGE_WITHOUT_CONVERSATIONID,
        'moodlewsrestformat': 'json',
        'messages[0][text]': text,
        'messages[0][touserid]': userIdFrom,
        'messages[0][textformat]': 1
      });

      return ConversationMessageModel(
          id: res.data[0]['msgid'],
          userIdFrom: res.data[0]['useridfrom'],
          text: text,
          conversationId: res.data[0]['conversationid'],
          timeCreated: res.data[0]['timecreated']);
    } catch (e) {
      if (kDebugMode) {
        print("Sent message Api error: $e");
      }
      rethrow;
    }
  }
}