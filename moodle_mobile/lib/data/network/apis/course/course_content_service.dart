import 'dart:async';

import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/constants/wsfunction_constants.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';
import 'package:dio/dio.dart';
import 'package:moodle_mobile/models/course/course_content.dart';

class CourseContentService {
  Future<List<CourseContent>> getCourseContent(String token, int id) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.GET_COURSE_CONTENTS,
        'moodlewsrestformat': 'json',
        'courseid': id,
      });

      if (res.data is Map<String, dynamic> &&
          (res.data as Map<String, dynamic>).containsKey("exception")) {
        throw res.data["errorcode"];
      }

      var list = res.data as List;

      return list.map((e) => CourseContent.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
