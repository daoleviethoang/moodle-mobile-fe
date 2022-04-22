import 'dart:async';

import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';
import 'package:moodle_mobile/models/course_category/course_category.dart';
import 'package:moodle_mobile/models/course_category/course_category_course.dart';
import 'package:dio/dio.dart';

class CourseCategoryApi {
  Future<List<CourseCategory>> getCourseCategory(String token) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': 'core_course_get_categories',
        'moodlewsrestformat': 'json',
      });

      var list = res.data as List;

      return list.map((e) => CourseCategory.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CourseCategoryCourse>> getCourseInFolder(
      String token, int idFolder) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': 'core_course_get_courses_by_field',
        'moodlewsrestformat': 'json',
        'field': 'category',
        'value': idFolder
      });

      var list = res.data["courses"] as List;

      return list.map((e) => CourseCategoryCourse.fromJson(e)).toList();
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
