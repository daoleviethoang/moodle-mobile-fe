import 'dart:async';

import 'package:dio/dio.dart';
import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/constants/wsfunction_constants.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';
import 'package:moodle_mobile/models/contact/contact.dart';
import 'package:moodle_mobile/models/course/courses.dart';
import 'package:moodle_mobile/models/search_user/message_contact.dart';

class SearchApi {
  // injecting dio instance
  SearchApi();

  Future<List<CourseOverview>> searchCourse(String token, String query) async {
    try {
      Dio dio = Http().client;

      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.CORE_COURSE_SEARCH_COURSES,
        'moodlewsrestformat': "json",
        'criterianame': "search",
        "criteriavalue": query,
      });
      var list = res.data["courses"] as List;

      return list
          .map((e) => CourseOverview(
              id: e["id"],
              title: e["displayname"],
              teacher: (e['contacts'] as List<dynamic>?)
                      ?.map((e) => Contact.fromJson(e as Map<String, dynamic>))
                      .toList() ??
                  []))
          .toList();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<List<MessageContact>> searchUser(
      String token, int userId, String query) async {
    try {
      Dio dio = Http().client;

      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.CORE_COURSE_SEARCH_USERS,
        'moodlewsrestformat': "json",
        'userid': userId,
        "search": query,
      });
      var list = res.data["contacts"] as List;
      list.addAll(res.data["noncontacts"]);

      return list.map((e) => MessageContact.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
