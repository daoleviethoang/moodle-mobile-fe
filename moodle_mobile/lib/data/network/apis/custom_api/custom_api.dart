import 'dart:async';

import 'package:dio/dio.dart';
import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/constants/wsfunction_constants.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';
import 'package:moodle_mobile/models/quiz/attempt.dart';
import 'package:moodle_mobile/models/quiz/quiz.dart';
import 'package:moodle_mobile/models/quiz/quizData.dart';

class CustomApi {
  Future<void> changeNameModule(String token, int moduleId, String name) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': "",
        'moodlewsrestformat': 'json',
      });
      if (res.data["exception"] != null) {
        throw res.data["exception"];
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
