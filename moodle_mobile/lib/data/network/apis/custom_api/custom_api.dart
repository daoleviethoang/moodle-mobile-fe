import 'dart:async';

import 'package:dio/dio.dart';
import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/constants/wsfunction_constants.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';

class CustomApi {
  Future<void> changeNameModule(String token, int moduleId, String name) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.LOCAL_EDIT_FOLDER_NAME,
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
        'wsfunction': Wsfunction.LOCAL_ADD_SECTION_COURSE,
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
      throw "Can't add section to course";
    }
  }

  Future<void> changeFileInFolderCourse(
      String token, int moduleId, int itemId) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.LOCAL_EDIT_FOLDER_FILES,
        'moodlewsrestformat': 'json',
        'id': moduleId,
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
        'wsfunction': Wsfunction.LOCAL_ADD_MODULES,
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
        'wsfunction': Wsfunction.LOCAL_ADD_MODULES,
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
        'wsfunction': Wsfunction.LOCAL_REMOVE_FOLDER_MODULE,
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

  Future<void> addLabel(String token, int courseId, String name, int sectionId,
      String description) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.LOCAL_ADD_MODULES,
        'moodlewsrestformat': 'json',
        'courseid': courseId,
        'modules[0][modulename]': 'label',
        'modules[0][section]': sectionId,
        'modules[0][name]': name,
        'modules[0][visible]': 1,
        'modules[0][description]': description,
        'modules[0][descriptionformat]': 0,
        'modules[0][options][0][name]': 'introformat',
        'modules[0][options][0][value]': 1,
      });
      if (res.data is Map<String, dynamic> && res.data["exception"] != null) {
        throw res.data["exception"];
      }
    } catch (e) {
      if (e.toString() == "dml_missing_record_exception") {
        throw e.toString();
      }
      throw "Can't add new label to course";
    }
  }

  Future<void> addAssignment(
    String token,
    int courseId,
    String name,
    int sectionId,
    String description,
    int timeStampOpen,
    int timeStampEnd,
  ) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.LOCAL_ADD_MODULES,
        'moodlewsrestformat': 'json',
        'courseid': courseId,
        'modules[0][modulename]': 'assign',
        'modules[0][section]': sectionId,
        'modules[0][name]': name,
        'modules[0][visible]': 1,
        'modules[0][description]': description,
        'modules[0][descriptionformat]': 0,
        'modules[0][options][0][name]': 'allowsubmissionsfromdate',
        'modules[0][options][0][value]': timeStampOpen,
        'modules[0][options][1][name]': 'duedate',
        'modules[0][options][1][value]': timeStampEnd,
        'modules[0][options][2][name]': 'cutoffdate',
        'modules[0][options][2][value]': timeStampEnd,
        'modules[0][options][3][name]': 'submissiondrafts',
        'modules[0][options][3][value]': 0,
        'modules[0][options][4][name]': 'requiresubmissionstatement',
        'modules[0][options][4][value]': 0,
        'modules[0][options][5][name]': 'sendnotifications',
        'modules[0][options][5][value]': 1,
        'modules[0][options][6][name]': 'sendlatenotifications',
        'modules[0][options][6][value]': 0,
        'modules[0][options][7][name]': 'gradingduedate',
        'modules[0][options][7][value]': timeStampEnd,
        'modules[0][options][8][name]': 'grade',
        'modules[0][options][8][value]': 100,
        'modules[0][options][9][name]': 'teamsubmission',
        'modules[0][options][9][value]': 0,
        'modules[0][options][10][name]': 'requireallteammemberssubmit',
        'modules[0][options][10][value]': 0,
        'modules[0][options][11][name]': 'blindmarking',
        'modules[0][options][11][value]': 0,
        'modules[0][options][12][name]': 'markingworkflow',
        'modules[0][options][12][value]': 0,
      });
      if (res.data is Map<String, dynamic> && res.data["exception"] != null) {
        throw res.data["exception"];
      }
    } catch (e) {
      if (e.toString() == "dml_missing_record_exception") {
        throw e.toString();
      }
      throw "Can't add new assign to course";
    }
  }

  Future<void> editAssignment(
    String token,
    int instanceId,
    String? name,
    int? timeStampOpen,
    int? timeStampEnd,
  ) async {
    try {
      Dio dio = Http().client;
      var map = {
        'wstoken': token,
        'wsfunction': Wsfunction.LOCAL_EDIT_ASSIGN,
        'moodlewsrestformat': 'json',
        'id': instanceId,
      };
      if (name != null) {
        map.addAll({
          'name': name,
        });
      }
      if (timeStampOpen != null) {
        map.addAll({
          'dayStart': timeStampOpen,
        });
      }
      if (timeStampEnd != null) {
        map.addAll({
          'dayEnd': timeStampEnd,
        });
      }
      final res =
          await dio.get(Endpoints.webserviceServer, queryParameters: map);
      if (res.data is Map<String, dynamic> && res.data["exception"] != null) {
        throw res.data["exception"];
      }
    } catch (e) {
      if (e.toString() == "dml_missing_record_exception") {
        throw e.toString();
      }
      throw "Can't edit assign to course";
    }
  }
}
