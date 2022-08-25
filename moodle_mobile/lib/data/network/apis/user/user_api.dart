import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/constants/wsfunction_constants.dart';
import 'package:moodle_mobile/data/network/dio_client.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';
import 'package:moodle_mobile/models/user.dart';
import 'package:moodle_mobile/models/user/user_overview.dart';

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
      if (kDebugMode) {
        print('$e');
      }
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

      return UserModel(
          id: res.data[0]['id'],
          token: token,
          baseUrl: Endpoints.baseUrl,
          username: res.data[0]['username'],
          fullname: res.data[0]['fullname'],
          photo: (res.data[0]['profileimageurl'] as String?)
              ?.replaceAll("pluginfile.php", "webservice/pluginfile.php"),
          email: res.data[0]['email'],
          city: res.data[0]['city'],
          country: res.data[0]['country']);
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
      rethrow;
    }
  }

  // Write a future return user info by id
  Future<List<UserOverview>> getUserById(String token, int id) async {
    try {
      Dio dio = Http().client;
      var res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.CORE_USER_GET_USERS_BY_FIELD,
        'moodlewsrestformat': 'json',
        'field': 'id',
        'values[0]': id
      });

      var list = res.data as List;
      if (list.isEmpty) {
        throw Exception('Cannot find this user !');
      }
      return list.map((e) => UserOverview.fromJson(e)).toList();
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
      rethrow;
    }
  }

  // upload avatar
  Future<bool> uploadAvatar(String token, int itemId) async {
    try {
      Dio dio = Http().client;
      var res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.CORE_USER_UPDATE_PRICTURE,
        'moodlewsrestformat': 'json',
        'draftitemid': itemId,
      });

      if (res.data["exception"] != null) {
        throw res.data["exception"];
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
      return false;
    }
  }

  // Write a future return user info by id
  Future<List<UserOverview>> getUserByIds(String token, List<int?> ids) async {
    try {
      Map<String, dynamic> queryParameters = {
        'wstoken': token,
        'wsfunction': Wsfunction.CORE_USER_GET_USERS_BY_FIELD,
        'moodlewsrestformat': 'json',
        'field': 'id',
      };
      for (int i = 0; i < ids.length; i++) {
        String values = 'values[' + i.toString() + ']';
        queryParameters[values] = ids[i];
      }
      Dio dio = Http().client;
      var res = await dio.get(Endpoints.webserviceServer,
          queryParameters: queryParameters);

      var list = res.data as List;
      if (list.isEmpty) {
        throw Exception('Cannot find this user !');
      }
      return list.map((e) => UserOverview.fromJson(e)).toList();
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
      rethrow;
    }
  }
}
