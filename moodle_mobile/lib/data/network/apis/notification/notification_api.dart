import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/constants/wsfunction_constants.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';
import 'package:moodle_mobile/models/notification/notification.dart';

class NotificationApi {
  static Future<NotificationPopup?> fetchPopup(String token,
      {String useridto = '0'}) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.MESSAGE_POPUP_GET_POPUP_NOTIFICATION,
        'moodlewsrestformat': 'json',
        'useridto': useridto,
      });
      var popup = NotificationPopup.fromJson(res.data);
      return popup;
    } catch (e) {
      if (kDebugMode) {
        print('!!!!!!!!!!$e');
      }
    }
  }
}