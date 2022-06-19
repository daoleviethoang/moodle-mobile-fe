import 'dart:async';

import 'package:dio/dio.dart';
import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';

class ForgotPassApi {
  Future<String?> forgotPass(String username) async {
    try {
      Dio dio = Http().client;

      var res = await dio.post(Endpoints.forgetPass, data: [
        {
          "index": 0,
          "methodname": "core_auth_request_password_reset",
          "args": {"username": username},
        }
      ]);

      print(res.data);

      if (res.data is Map<String, dynamic> && res.data["error"] != null) {
        throw res.data["error"];
      }

      if (res.data is List && res.data[0]["data"]["status"] == "dataerror") {
        return null;
      }

      if (res.data is List && res.data[0]["data"]["notice"] != null) {
        return res.data[0]["data"]["notice"];
      }

      return "Email sended";
    } catch (e) {
      rethrow;
    }
  }
}
