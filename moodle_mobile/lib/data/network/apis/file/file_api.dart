import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:permission_handler/permission_handler.dart';

class FileApi {
  Future<int> uploadFile(String token, String filePath, int? itemid) async {
    try {
      Dio dio = Http().client;
      final res = await dio.post(Endpoints.uploadFile, queryParameters: {
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

  downloadFile(String token, String fileUrl, String fileName) async {
    try {
      final status = await Permission.storage.request();
      if (status.isGranted) {
        var storage = await pathProvider.getExternalStorageDirectory();
        Dio dio = Http().client;
        await FlutterDownloader.enqueue(
          url: fileUrl + "?token=$token",
          savedDir: storage!.path,
          fileName: fileName,
          showNotification:
              true, // show download progress in status bar (for Android)
          openFileFromNotification:
              true, // click on notification to open downloaded file (for Android)
        );
        return;
      } else {
        throw "App don't have permission download";
      }
    } catch (e) {
      print(e.toString());
      throw "Can't download file";
    }
  }
}
