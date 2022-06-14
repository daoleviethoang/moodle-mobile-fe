import 'dart:async';

import 'package:dio/dio.dart';
import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';

class CustomApi {
  Future<void> changeNameModule(String token, int moduleId, String name) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': "local_modulews_edit_folder_name_module",
        'moodlewsrestformat': 'json',
        'id': moduleId,
        'name': name,
      });
      if (res.data is Map<String, dynamic> && res.data["exception"] != null) {
        throw res.data["exception"];
      }
    } catch (e) {
      if (e.toString() == "dml_missing_record_exception") {
        throw e.toString();
      }
      throw "Can't change name module";
    }
  }

  Future<void> addSectionCourse(String token, int courseId, String name) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': "local_modulews_add_section_course",
        'moodlewsrestformat': 'json',
        'courseid': courseId,
        'name': name,
      });
      if (res.data is Map<String, dynamic> && res.data["exception"] != null) {
        throw res.data["exception"];
      }
    } catch (e) {
      if (e.toString() == "dml_missing_record_exception") {
        throw e.toString();
      }
      print(e.toString());
      throw "Can't add section to course";
    }
  }

  Future<void> changeFileInFolderCourse(
      String token, int moduleId, int itemId) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': "local_modulews_edit_folder_files",
        'moodlewsrestformat': 'json',
        'courseid': moduleId,
        'itemId': itemId,
      });
      if (res.data is Map<String, dynamic> && res.data["exception"] != null) {
        throw res.data["exception"];
      }
    } catch (e) {
      if (e.toString() == "dml_missing_record_exception") {
        throw e.toString();
      }
      throw "Can't change folder file";
    }
  }

  Future<void> addModuleFolder(String token, int courseId, String name,
      int sectionId, int itemId) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': "local_modulews_add_modules",
        'moodlewsrestformat': 'json',
        'courseid': courseId,
        'modules[0][modulename]': 'folder',
        'modules[0][section]': sectionId,
        'modules[0][name]': name,
        'modules[0][visible]': 1,
        'modules[0][description]': '',
        'modules[0][descriptionformat]': 0,
        'modules[0][options][0][name]': 'files',
        'modules[0][options][0][value]': itemId,
        'modules[0][options][1][name]': 'display',
        'modules[0][options][1][value]': 1,
      });
      if (res.data is Map<String, dynamic> && res.data["exception"] != null) {
        throw res.data["exception"];
      }
    } catch (e) {
      print(e.toString());
      if (e.toString() == "dml_missing_record_exception") {
        throw e.toString();
      }
      throw "Can't add new folder to course";
    }
  }

  Future<void> addModuleUrl(String token, int courseId, String name,
      int sectionId, String url) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': "local_modulews_add_modules",
        'moodlewsrestformat': 'json',
        'courseid': courseId,
        'modules[0][modulename]': 'url',
        'modules[0][section]': sectionId,
        'modules[0][name]': name,
        'modules[0][visible]': 1,
        'modules[0][description]': '',
        'modules[0][descriptionformat]': 0,
        'modules[0][options][0][name]': 'externalurl',
        'modules[0][options][0][value]': url,
        'modules[0][options][1][name]': 'display',
        'modules[0][options][1][value]': 6,
      });
      if (res.data is Map<String, dynamic> && res.data["exception"] != null) {
        throw res.data["exception"];
      }
    } catch (e) {
      if (e.toString() == "dml_missing_record_exception") {
        throw e.toString();
      }
      throw "Can't add new url to course";
    }
  }

  Future<void> deleteModuleInCourse(String token, int moduleId) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': "local_modulews_remove_folder_module_course",
        'moodlewsrestformat': 'json',
        'cmid': moduleId,
      });
      if (res.data is Map<String, dynamic> && res.data["exception"] != null) {
        throw res.data["exception"];
      }
    } catch (e) {
      if (e.toString() == "dml_missing_record_exception") {
        throw e.toString();
      }
      print(e.toString());
      throw "Can't remove module";
    }
  }
}
