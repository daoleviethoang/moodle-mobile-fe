import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:moodle_mobile/data/network/apis/file/file_api.dart';
import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/constants/wsfunction_constants.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';
import 'package:moodle_mobile/models/assignment/file_assignment.dart';
import 'package:moodle_mobile/models/forum/forum_course.dart';
import 'package:moodle_mobile/models/forum/forum_discussion.dart';
import 'package:moodle_mobile/models/forum/forum_post.dart';

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
        'wsfunction': Wsfunction.MOD_FORUM_GET_FORUMS_BY_COURSES,
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
    } catch (e) {
      if (kDebugMode) {
        print('!!!!!!!!!!$e');
      }
    }
    return null;
  }

  Future<List<ForumDiscussion>?> getForumDiscussion(
      String token, int forumid) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.MOD_FORUM_GET_FORUM_DISCUSSIONS,
        'moodlewsrestformat': "json",
        'forumid': forumid
      });
      var list = res.data["discussions"] as List;
      List<ForumDiscussion> temp =
          list.map((e) => ForumDiscussion.fromJson(e)).toList();
      return temp;
    } catch (e) {
      if (kDebugMode) {
        print('!!!!!!!!!!$e');
      }
    }
    return null;
  }

  // get all post in dicussion
  Future<List<ForumPost>?> getForumPost(String token, int discussionid) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.MOD_FORUM_GET_DISCUSSION_POSTS,
        'moodlewsrestformat': "json",
        'discussionid': discussionid
      });
      var list = res.data['posts'] as List;
      print(list);
      List<ForumPost> temp = list.map((e) => ForumPost.fromJson(e)).toList();
      return temp;
    } catch (e) {
      if (kDebugMode) {
        print('!!!!!!!!!!$e');
      }
    }
    return null;
  }

  // post 1 post in forum
  postAPost(String token, int forumId, String subject, String message,
      List<FileUpload> files) async {
    try {
      Dio dio = Http().client;

      var query = {
        'wstoken': token,
        'wsfunction': Wsfunction.MOD_FORUM_ADD_DISCUSSION,
        'moodlewsrestformat': "json",
        'forumid': forumId,
        "subject": subject,
        "message": message,
      };

      if (files.isNotEmpty) {
        int? itemId = await FileApi().uploadMultipleFile(token, files);
        if (itemId != null) {
          query = {
            'wstoken': token,
            'wsfunction': Wsfunction.MOD_FORUM_ADD_DISCUSSION,
            'moodlewsrestformat': "json",
            'forumid': forumId,
            "subject": subject,
            "message": message,
            "options[0][name]": "attachmentsid",
            "options[0][value]": itemId,
          };
        }
      }

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
      List<FileUpload> files) async {
    try {
      Dio dio = Http().client;

      var query = {
        'wstoken': token,
        'wsfunction': Wsfunction.MOD_FORUM_ADD_DISCUSSION_POST,
        'moodlewsrestformat': "json",
        'postid': postId,
        "subject": subject,
        "message": message,
      };

      if (files.isNotEmpty) {
        int? itemId = await FileApi().uploadMultipleFile(token, files);
        if (itemId != null) {
          query = {
            'wstoken': token,
            'wsfunction': Wsfunction.MOD_FORUM_ADD_DISCUSSION_POST,
            'moodlewsrestformat': "json",
            'postid': postId,
            "subject": subject,
            "message": message,
            "options[0][name]": "attachmentsid",
            "options[0][value]": itemId,
          };
        }
      }

      final res =
          await dio.get(Endpoints.webserviceServer, queryParameters: query);

      if (res.data["exception"] != null) {
        throw res.data["exception"];
      }

      return;
    } catch (e) {
      rethrow;
    }
  }

  //Subscrible a discussion post
  subscriblePost(String token, int forumId, int state, int discussionId) {
    try {
      // Dio dio = Http().client;
      var query = {
        'wstoken': token,
        'wsfunction': Wsfunction.MOD_FORUM_SET_SUBSCRIPTION,
        'moodlewsrestformat': "json",
        'forumid': forumId,
        'targetstate': state,
        'discussionid': discussionId,
      };
      return;
    } catch (e) {
      if (kDebugMode) {
        print('!!!!!!!!!!$e');
      }
    }
  }
}