import 'dart:async';

import 'package:dio/dio.dart';
import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/constants/wsfunction_constants.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';

class EnrollApi {
  // injecting dio instance
  EnrollApi();

  /// Returns list of post in response
  Future<bool> enroll(String token, int courseId, String enrollKey) async {
    try {
      Dio dio = Http().client;

      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.ENROL_SELF_ENROL_USER,
        'moodlewsrestformat': "json",
        'courseid': courseId,
        "password": enrollKey,
      });

      return res.data["status"];
    } catch (e) {
      return false;
    }
  }
}
