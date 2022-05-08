import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';
import 'package:moodle_mobile/models/notification/notification.dart';

class NotificationApi {
  static Future<NotificationPopup?> fetchPopup(String token,
      {String useridto = '0'}) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': 'message_popup_get_popup_notifications',
        'moodlewsrestformat': 'json',
        'useridto': useridto,
      });
      var popup = NotificationPopup.fromJson(res.data);
      print(true);
      return popup;
    } catch (e) {}
    return null;
  }
}
