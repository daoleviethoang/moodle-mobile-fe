import 'dart:async';

import 'package:dio/dio.dart';
import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/constants/wsfunction_constants.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';

class EnrolApi {
  // injecting dio instance
  EnrolApi();

  /// Returns list of post in response
  Future<bool> enrol(String token, int courseId, String enrollKey) async {
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

  // null if can't enrol, true have pass, false don't have pass
  Future<bool?> haveEnrolPass(String token, int courseId) async {
    try {
      Dio dio = Http().client;

      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.ENROL_GET_COURSE_ENROL_METHODS,
        'moodlewsrestformat': "json",
        'courseid': courseId,
      });

      var list = res.data as List;
      var selfEnrol = list.where((element) => element["type"] == "self").first;

      if (selfEnrol["status"] != true) {
        return null;
      }

      if (selfEnrol["wsfunction"] != null) {
        return true;
      }

      return false;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
