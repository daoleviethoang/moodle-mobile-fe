import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
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
}
