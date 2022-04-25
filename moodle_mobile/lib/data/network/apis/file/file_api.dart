import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';

class FileApi {
  Future<int> uploadFile(String token, String filePath, int? itemid) async {
    try {
      Dio dio = Http().client;
      final res = await dio.post(Endpoints.webserviceServer, queryParameters: {
        'token': token,
        'filearea': 'draft',
        'itemid': itemid,
      }, data: {
        'file': await MultipartFile.fromFile(filePath),
      });
      if (res.data["error"] != null) {
        throw res.data["error"];
      }
      return res.data["itemid"];
    } catch (e) {
      throw "Upload file fail";
    }
  }

  Future<int> downloadFile(String token, String fileUrl) async {
    try {
      Dio dio = Http().client;
      final res = await dio.download(fileUrl, "", queryParameters: {
        'token': token,
      });
      if (res.data["error"] != null) {
        throw "Can't download file";
      }
      return res.data["itemid"];
    } catch (e) {
      throw "Can't download file";
    }
  }
}
