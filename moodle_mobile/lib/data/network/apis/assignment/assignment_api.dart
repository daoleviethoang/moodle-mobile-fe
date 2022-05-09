import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/constants/wsfunction_constants.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';
import 'package:moodle_mobile/models/assignment/assignment.dart';
import 'package:moodle_mobile/models/assignment/attemp_assignment.dart';

class AssignmentApi {
  saveAssignment(String token, int assignid, int itemid) async {
    try {
      Dio dio = Http().client;
      var res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.MOD_ASSIGNMENT_SAVE_SUBMISSION,
        "moodlewsrestformat": "json",
        'assignmentid': assignid,
        'plugindata[files_filemanager]': itemid,
      });

      if (res.data is Map<String, dynamic> &&
          (res.data as Map<String, dynamic>).containsKey("exception")) {
        throw res.data["exception"];
      }

      List list = res.data as List;

      if (list.isNotEmpty && (res.data[0]["warningcode"] ?? "").isNotEmpty) {
        throw res.data[0]["warningcode"];
      }
      return;
    } catch (e) {
      print(e.toString());
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

      if (res.data["exception"] != null) {
        throw res.data["exception"];
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
      if (res.data["exception"] != null) {
        throw res.data["exception"];
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
