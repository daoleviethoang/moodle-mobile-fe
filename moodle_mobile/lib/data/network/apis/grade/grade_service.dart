import 'dart:async';

import 'package:dio/dio.dart';
import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/constants/wsfunction_constants.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';
import 'package:moodle_mobile/models/assignment/feedback.dart';

class GradeService {
  Future<List<Grade>> getGrades(String token) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.GRADEREPORT_COURSE_GRADES,
        "moodlewsrestformat": "json",
      });

      var list = res.data["grades"] as List;
      return list.map((e) => Grade.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}