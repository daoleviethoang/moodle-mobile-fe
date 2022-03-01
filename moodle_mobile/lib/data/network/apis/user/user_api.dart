import 'dart:async';

import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/dio_client.dart';

class UserApi {
  // dio instance
  final DioClient _dioClient;

  // injecting dio instance
  UserApi(this._dioClient);

  /// Returns list of post in response
  Future<String> login(String username, String password, String service) async {
    try {
      final res = await _dioClient.get(Endpoints.login, queryParameters: {
        'username': username,
        'password': password,
        'service': service
      });

      if (res['token'] == null) {
        throw Exception('Wrong username or password, please try again!');
      }

      return res['token'];
    } catch (e) {
      rethrow;
    }
  }
}
