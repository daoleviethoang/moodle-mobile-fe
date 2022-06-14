import 'dart:async';

import 'package:dio/dio.dart';
import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/constants/wsfunction_constants.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';
import 'package:moodle_mobile/models/site_info/site_info.dart';

class SiteInfoApi {
  Future<SiteInfo> getSiteInfo(String token) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.CORE_WEBSERVICE_GET_SITE_INFO,
        'moodlewsrestformat': 'json',
      });
      if (res.data["exception"] != null) {
        throw res.data["exception"];
      }

      return SiteInfo.fromJson(res.data);
    } catch (e) {
      throw "Can't get site info";
    }
  }
}
