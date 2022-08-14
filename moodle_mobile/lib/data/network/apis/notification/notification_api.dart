import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/constants/wsfunction_constants.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';
import 'package:moodle_mobile/models/notification/notification.dart';

class NotificationApi {
  static Future<NotificationPopup?> fetchPopup(String token,
      {int useridto = 0, int read = 1, int limitnum = 0}) async {
    try {
      Dio dio = Http().client;
      // final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
      //   'wstoken': token,
      //   'wsfunction': Wsfunction.MESSAGE_POPUP_GET_POPUP_NOTIFICATION,
      //   'moodlewsrestformat': 'json',
      //   'useridto': useridto,
      // });
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.CORE_MESSAGE_GET_MESSAGES,
        'moodlewsrestformat': 'json',
        'useridto': useridto,
        'type': 'both',
        'read': read,
        'limitnum': limitnum,
      });
      var popup = NotificationPopup.fromJson(res.data);

      return popup;
    } catch (e) {
      if (kDebugMode) print('!!!!!!!!!!$e');
    }
  }

  static Future markAllAsRead(String token, {String useridto = '0'}) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.MARK_ALL_NOTIFICATION_AS_READ,
        'moodlewsrestformat': 'json',
        'useridto': useridto,
      });
    } catch (e) {
      if (kDebugMode) print('!!!!!!!!!!$e');
    }
  }

  static Future markMessageAsRead(String token, int id, int userid) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.MARK_MESSAGE_AS_READ,
        'moodlewsrestformat': 'json',
        'messageid': id,
      });
      print(res);
    } catch (e) {
      if (kDebugMode) print('!!!!!!!!!!$e');
    }
  }

  static Future markNotifcationAsRead(String token, int id) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.MARK_NOTIFICATION_AS_READ,
        'moodlewsrestformat': 'json',
        'notificationid': id,
      });
      print(res);
    } catch (e) {
      if (kDebugMode) print('!!!!!!!!!!$e');
    }
  }

  static Future<int> getUnreadCount(String token,
      {String useridto = '0'}) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.GET_UNREAD_NOTIFICATIONS_COUNT,
        'moodlewsrestformat': 'json',
        'useridto': useridto,
      });
      if (res.data is Map) {
        if (res.data['errorcode'] == 'accessdenied') return 0;
        throw Exception(res.data);
      }
      return res.data;
    } catch (e) {
      if (kDebugMode) print('!!!!!!!!!!$e');
      return 0;
    }
  }
}
