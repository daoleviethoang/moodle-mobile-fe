import 'dart:async';
import 'dart:convert';

import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/dio_client.dart';
import 'package:moodle_mobile/models/user.dart';

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

  // Write a future return user info
  Future<UserModel> getUserInfo(String token, String username) async {
    try {
      final res = await _dioClient.get(Endpoints.userInfo, queryParameters: {
        'wstoken': token,
        'wsfunction': 'core_user_get_users_by_field',
        'moodlewsrestformat': 'json',
        'field': 'username',
        'values[0]': username
      });

      // Handle error
      if (res.runtimeType == [].runtimeType) {
        if (res.length == 0) {
          throw Exception('Can not found user info!');
        }
      } else {
        throw Exception(res['message']);
      }

      return UserModel(
          id: res[0]['id'],
          token: token,
          username: res[0]['username'],
          fullname: res[0]['fullname'],
          email: res[0]['email']);
    } catch (e) {
      rethrow;
    }
  }
}
