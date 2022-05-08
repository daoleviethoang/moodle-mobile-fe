import 'dart:async';

import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/constants/wsfunction_constants.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';
import 'package:dio/dio.dart';
import 'package:moodle_mobile/models/course/course.dart';
import 'package:moodle_mobile/models/course/course_content.dart';
import 'package:moodle_mobile/models/course_category/course_category_course.dart';

class CourseContentService {
  static Future<List<CourseContent>> getCourseContent(
      String token, int id) async {
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

  static Future<CourseCategoryCourse> getCourseById(String token, int id) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.GET_COURSE_BY_FIELD,
        'moodlewsrestformat': 'json',
        'value': id,
        'field': 'id',
      });

      var list = (res.data as Map)['courses'];

      return CourseCategoryCourse.fromJson(list[0]);
    } catch (e) {
      rethrow;
    }
  }
}