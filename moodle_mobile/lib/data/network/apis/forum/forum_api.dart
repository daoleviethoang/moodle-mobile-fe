import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/dio_client.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';
import 'package:moodle_mobile/models/assignment/file_assignment.dart';
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

  // post 1 post in forum
  postAPost(String token, int forumId, String subject, String message,
      List<FileAssignment> files) async {
    try {
      Dio dio = Http().client;

      var query = {
        'wstoken': token,
        'wsfunction': "mod_forum_add_discussion",
        'moodlewsrestformat': "json",
        'forumid': forumId,
        "subject": subject,
        "message": message,
      };

      if (files.isNotEmpty) {}

      final res =
          await dio.get(Endpoints.webserviceServer, queryParameters: query);

      if (res.data["error"] != null) {
        throw res.data["error"];
      }

      return;
    } catch (e) {
      rethrow;
    }
  }

  relyAPost(String token, int postId, String subject, String message,
      List<FileAssignment> files) async {
    try {
      Dio dio = Http().client;

      var query = {
        'wstoken': token,
        'wsfunction': "mod_forum_add_discussion",
        'moodlewsrestformat': "json",
        'postid': postId,
        "subject": subject,
        "message": message,
      };

      if (files.isNotEmpty) {}

      final res =
          await dio.get(Endpoints.webserviceServer, queryParameters: query);

      if (res.data["error"] != null) {
        throw res.data["error"];
      }

      return;
    } catch (e) {
      rethrow;
    }
  }
}
