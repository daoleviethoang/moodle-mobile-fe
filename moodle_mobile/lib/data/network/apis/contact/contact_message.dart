import 'package:moodle_mobile/data/network/dio_http.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/constants/wsfunction_constants.dart';
import 'package:moodle_mobile/models/conversation/conversation_member.dart';

class ContactOfMessage {
  Future<List<ConversationMemberModel>> getUserContact(
    String token,
    int userId,
  ) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.CORE_USER_CONTACT,
        'moodlewsrestformat': 'json',
        'userid': userId,
      });

      List<ConversationMemberModel> listUserContact = [];
      for (var i = 0; i < (res.data as List).length; i++) {
        listUserContact.add(ConversationMemberModel(
            id: res.data[i]['id'],
            fullname: res.data[i]['fullname'],
            profileImageURL: res.data[i]['profileimageurl']));
      }
      return listUserContact;
    } catch (e) {
      rethrow;
    }
  }
}