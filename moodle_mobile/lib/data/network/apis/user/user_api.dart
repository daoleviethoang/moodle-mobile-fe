import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/constants/wsfunction_constants.dart';
import 'package:moodle_mobile/data/network/dio_client.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';
import 'package:moodle_mobile/models/user.dart';

class UserApi {
  // dio instance
  final DioClient _dioClient;

  // injecting dio instance
  UserApi(this._dioClient);

  /// Returns list of post in response
  Future<String> login(String username, String password, String service) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.login, queryParameters: {
        'username': username,
        'password': password,
        'service': service
      });

      if (res.data['token'] == null) {
        throw Exception('Wrong username or password, please try again!');
      }

      return res.data['token'];
    } catch (e) {
      rethrow;
    }
  }

  // Write a future return user info
  Future<UserModel> getUserInfo(String token, String username) async {
    try {
      Dio dio = Http().client;
      var res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.CORE_USER_GET_USERS_BY_FIELD,
        'moodlewsrestformat': 'json',
        'field': 'username',
        'values[]': [username]
      });
      print("here user api");

      return UserModel(
          id: res.data[0]['id'],
          token: token,
          baseUrl: Endpoints.baseUrl,
          username: res.data[0]['username'],
          fullname: res.data[0]['fullname'],
          email: res.data[0]['email']);
    } catch (e) {
      print("Error here");
      rethrow;
    }
  }
}
