import 'dart:async';

import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';
import 'package:dio/dio.dart';
import 'package:moodle_mobile/models/course/course.dart';
import 'package:moodle_mobile/models/course/course_content.dart';

class CourseApi {
  static Future<List<CourseContent>> getCourseContent(
      String token, String id) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': 'core_course_get_contents',
        'moodlewsrestformat': 'json',
        'courseid': id,
      });

      var list = res.data as List;

      return list.map((e) => CourseContent.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  static Future<Course> getCourseById(String token, String id) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': 'core_course_get_courses_by_field',
        'moodlewsrestformat': 'json',
        'value': id,
        'field': 'id',
      });

      var list = (res.data as Map)['courses'];

      return Course.fromJson(list[0]);
    } catch (e) {
      rethrow;
    }
  }
}