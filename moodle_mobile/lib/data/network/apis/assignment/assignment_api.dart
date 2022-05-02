import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/constants/wsfunction_constants.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';
import 'package:moodle_mobile/models/assignment/assignment.dart';
import 'package:moodle_mobile/models/assignment/attemp_assignment.dart';

class AssignmentApi {
  void saveAssignment(String token, int assignid, int itemid) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.MOD_ASSIGNMENT_SAVE_SUBMISSION,
        "moodlewsrestformat": "json",
        'assignmentid': assignid,
        'plugindata[files_filemanager]': itemid,
      });
      if (res.data["error"] != null) {
        throw res.data["error"];
      }
      return;
    } catch (e) {
      throw "Save asignment fail";
    }
  }

  Future<List<Assignment>> getAssignments(
      String token, int assignInstanceId, int courseId) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.MOD_ASSIGN_GET_ASSIGNMENTS,
        "moodlewsrestformat": "json",
        'courseids[]': courseId,
      });

      if (res.data["error"] != null) {
        throw res.data["error"];
      }
      final list = res.data['courses'][0]['assignments'] as List;

      List<Assignment> assigns =
          list.map((e) => Assignment.fromJson(e)).toList();

      return assigns;
    } catch (e) {
      throw "Can't get list assignment";
    }
  }

  Future<AttemptAssignment> getAssignment(
      String token, int assignInstanceId) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.MOD_ASSIGN_GET_SUBMISSION_STATUS,
        "moodlewsrestformat": "json",
        'assignid': assignInstanceId,
      });
      if (res.data["error"] != null) {
        throw res.data["error"];
      }
      final data = res.data['lastattempt'] as Map<String, dynamic>;
      AttemptAssignment temp = AttemptAssignment.fromJson(data);
      return temp;
    } catch (e) {
      print(e.toString());
      throw "Can't get list assignment";
    }
  }
}
