import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:permission_handler/permission_handler.dart';
import 'package:moodle_mobile/models/assignment/file_assignment.dart';

class FileApi {
  Future<int> uploadFile(
      String token, String filePath, String? fileName, int? itemid) async {
    try {
      Dio dio = Http().client;
      Response<dynamic> res;
      var formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
      });
      Map<String, Object> query = {
        'token': token,
        'filearea': 'draft',
      };
      if (itemid != null) {
        query = {
          'token': token,
          'filearea': 'draft',
          'itemid': itemid,
        };
      }
      res = await dio.post(Endpoints.uploadFile,
          queryParameters: query, data: formData);

      var data = jsonDecode(res.data);
      if (data[0]["error"] != null) {
        throw data[0]["error"];
      }
      return data[0]["itemid"];
    } catch (e) {
      throw "Upload file fail $fileName";
    }
  }

  Future<int?> uploadMultipleFile(String token, List<FileUpload> files) async {
    try {
      if (files.isEmpty) {
        return null;
      }
      int itemId = await FileApi()
          .uploadFile(token, files.first.filepath, files.first.filename, null);
      for (int i = 1; i < files.length; i++) {
        await FileApi()
            .uploadFile(token, files[i].filepath, files[i].filename, itemId);
      }
      return itemId;
    } catch (e) {
      rethrow;
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
