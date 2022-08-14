import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/constants/wsfunction_constants.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';
import 'package:moodle_mobile/models/course/course.dart';

class CourseService {
  Future<List<Course>> getCourses(String token, int userId) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.GET_USERS_COURSES,
        "moodlewsrestformat": "json",
        'userid': userId,
      });

      var list = res.data as List;
      return list.map((e) => Course.fromJson(e)).toList();
    } catch (e) {
      rethrow;
      //throw "Can't get list courses by user";
    }
  }

  Future<String?> getGrade(String token, int courseId) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.GRADEREPORT_COURSE_GRADES,
        "moodlewsrestformat": "json",
      });

      var list = res.data["grades"] as List;

      for (var item in list) {
        if (item["courseid"] == courseId) {
          return item["grade"];
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future triggerViewCourse(String token, int id) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.TRIGGER_VIEW_COURSE,
        'moodlewsrestformat': 'json',
        'courseid': id,
      });

      List<dynamic>? warnings = (res.data as Map)['warnings'];
      if ((warnings ?? []).isNotEmpty) {
        throw Exception(jsonEncode(warnings));
      }
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
      rethrow;
    }
  }

  Future setFavouriteCourse(String token, int id, int value) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.SET_FAVOURITE_COURSE,
        'moodlewsrestformat': 'json',
        'courses[0][id]': id,
        'courses[0][favourite]': value
      });

      List<dynamic>? warnings = (res.data as Map)['warnings'];
      if ((warnings ?? []).isNotEmpty) {
        throw Exception(jsonEncode(warnings));
      }
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
      rethrow;
    }
  }

  Future setHiddenCourse(String token, int id) async {
    try {
      Dio dio = Http().client;
      await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.CORE_USER_UPDATE_USER_PREFERENCES,
        'moodlewsrestformat': 'json',
        'preferences[0][type]':
            'block_myoverview_hidden_course_' + id.toString(),
        'preferences[0][value]': 1
      });
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
      rethrow;
    }
  }

  Future setUnHiddenCourse(String token, int id) async {
    try {
      Dio dio = Http().client;
      await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.CORE_USER_UPDATE_USER_PREFERENCES,
        'moodlewsrestformat': 'json',
        'preferences[0][type]':
            'block_myoverview_hidden_course_' + id.toString(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
      rethrow;
    }
  }
}