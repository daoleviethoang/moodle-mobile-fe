import 'dart:async';

import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/constants/wsfunction_constants.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';
import 'package:dio/dio.dart';
import 'package:moodle_mobile/models/course/course_detail.dart';

class CourseDetailService {
  Future<CourseDetail> getCourseById(String token, int id) async {
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

      return CourseDetail.fromJson(list[0]);
    } catch (e) {
      print('$e');
      rethrow;
    }
  }
}