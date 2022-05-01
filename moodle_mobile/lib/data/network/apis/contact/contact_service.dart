import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/constants/wsfunction_constants.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';
import 'package:moodle_mobile/models/contact/contact.dart';

class ContactService {
  Future<List<Contact>> getContacts(String token, int courseId) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.GET_ENROLLED_USERS,
        "moodlewsrestformat": "json",
        'courseid': courseId,
      });

      var list = res.data as List;
      return list.map((e) => Contact.fromJson(e)).toList();
    } catch (e) {
      rethrow;
      //throw "Can't get list courses by user";
    }
  }
}
