import 'dart:async';

import 'package:dio/dio.dart';
import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';

class ForgotPassApi {
  Future<bool> forgotPass(String token, String username) async {
    try {
      Dio dio = Http().client;

      var res = await dio.post(Endpoints.forgetPass, data: [
        {
          "index": 0,
          "methodname": "core_auth_request_password_reset",
          "args": {"username": username},
        }
      ]);

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
