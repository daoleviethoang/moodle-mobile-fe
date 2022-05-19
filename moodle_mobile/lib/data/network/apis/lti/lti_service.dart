import 'dart:async';

import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/constants/wsfunction_constants.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';
import 'package:dio/dio.dart';
import 'package:moodle_mobile/models/lti/lti.dart';

class LtiService {
  Future<Lti> getLti(String token, int id) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.MOD_LTI_GET_TLD,
        'moodlewsrestformat': 'json',
        'toolid': id,
      });

      return Lti.fromJson(res.data);
    } catch (e) {
      rethrow;
    }
  }
}