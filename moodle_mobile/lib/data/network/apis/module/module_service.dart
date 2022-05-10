import 'dart:async';

import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/constants/wsfunction_constants.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';
import 'package:dio/dio.dart';
import 'package:moodle_mobile/models/module/module_course.dart';

class ModuleService {
  Future<ModuleCourse> getModule(String token, int id) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.GET_MODULE_BY_ID,
        'moodlewsrestformat': 'json',
        'cmid': id,
      });

      var cm = res.data['cm'];

      return ModuleCourse.fromJson(cm);
    } catch (e) {
      rethrow;
    }
  }
}