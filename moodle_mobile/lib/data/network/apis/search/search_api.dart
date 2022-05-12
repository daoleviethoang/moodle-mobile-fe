import 'dart:async';

import 'package:dio/dio.dart';
import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/constants/wsfunction_constants.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';
import 'package:moodle_mobile/models/contact/contact.dart';
import 'package:moodle_mobile/models/course/courses.dart';

class SearchApi {
  // injecting dio instance
  SearchApi();

  /// Returns list of post in response
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
}
