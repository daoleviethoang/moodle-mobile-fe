import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:moodle_mobile/data/network/apis/file/file_api.dart';
import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/constants/wsfunction_constants.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';
import 'package:moodle_mobile/models/assignment/file_assignment.dart';
import 'package:moodle_mobile/models/forum/forum_course.dart';
import 'package:moodle_mobile/models/notification_preference/notification_preference.dart';

class NotificationPreferenceApi {
  // injecting dio instance
  NotificationPreferenceApi();

  // post 1 post in forum
  Future<NotificationPreference?> getData(String token) async {
    try {
      Dio dio = Http().client;

      var query = {
        'wstoken': token,
        'wsfunction': Wsfunction.CORE_MESSAGE_GET_USER_NOTIFICATION_PREFERENCES,
        'moodlewsrestformat': "json",
      };

      final res =
          await dio.get(Endpoints.webserviceServer, queryParameters: query);

      if (res.data["error"] != null) {
        throw res.data["error"];
      }

      NotificationPreference data =
          NotificationPreference.fromJson(res.data["preferences"]);

      return data;
    } catch (e) {
      rethrow;
    }
  }

  setAllNotificationPreference(String token, bool value) async {
    try {
      Dio dio = Http().client;

      var query = {
        'wstoken': token,
        'wsfunction': Wsfunction.CORE_USER_UPDATE_USER_PREFERENCE,
        'moodlewsrestformat': "json",
        "emailstop": value ? "1" : "0",
      };

      final res =
          await dio.get(Endpoints.webserviceServer, queryParameters: query);

      if (res.data != null && res.data["error"] != null) {
        throw res.data["error"];
      }

      return;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setNotificationPreference(
      String token, String preferencekey, List<String> namePreference) async {
    try {
      Dio dio = Http().client;

      var query = {
        'wstoken': token,
        'wsfunction': Wsfunction.CORE_USER_UPDATE_USER_PREFERENCE,
        'moodlewsrestformat': "json",
        "preferences[0][type]": preferencekey,
        "preferences[0][value]": namePreference.join(","),
      };

      final res =
          await dio.get(Endpoints.webserviceServer, queryParameters: query);

      if (res.data != null && res.data["error"] != null) {
        throw res.data["error"];
      }

      return;
    } catch (e) {
      rethrow;
    }
  }
}
