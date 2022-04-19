import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/dio_client.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';
import 'package:moodle_mobile/models/forum/forum_course.dart';
import 'package:moodle_mobile/models/user.dart';

class ForumApi {
  // injecting dio instance
  ForumApi();

  /// Returns list of post in response
  Future<ForumCourse?> getForums(
      String token, int courseId, int forumId) async {
    try {
      Dio dio = Http().client;

      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': "mod_forum_get_forums_by_courses",
        'moodlewsrestformat': "json",
        'courseids[]': [courseId],
      });
      var list = res.data as List;

      List<ForumCourse> forums =
          list.map((e) => ForumCourse.fromJson(e)).toList();
      for (var item in forums) {
        if (item.id == forumId) {
          return item;
        }
      }
      return null;
    } catch (e) {}
    return null;
  }
}
