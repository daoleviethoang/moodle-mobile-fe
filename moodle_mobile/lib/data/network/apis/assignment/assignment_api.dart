import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/constants/wsfunction_constants.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';
import 'package:moodle_mobile/models/assignment/assignment.dart';
import 'package:moodle_mobile/models/assignment/attemp_assignment.dart';
import 'package:moodle_mobile/models/assignment/feedback.dart';
import 'package:moodle_mobile/models/assignment/user_submited.dart';
import 'package:moodle_mobile/models/comment/comment.dart';

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

      if (res.data is Map<String, dynamic> && res.data["exception"] != null) {
        throw res.data["exception"];
      }
      final list = res.data['courses'][0]['assignments'] as List;

      List<Assignment> assigns =
          list.map((e) => Assignment.fromJson(e)).toList();

      return assigns;
    } catch (e) {
      print('!!!!!!!!!!$e');
      throw "Can't get list assignment";
    }
  }

  Future<FeedBack> getAssignmentFeedbackAndGrade(
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
      if (res.data["feedback"] == null) {
        return FeedBack();
      }

      FeedBack feedback = FeedBack.fromJson(res.data["feedback"]);

      return feedback;
    } catch (e) {
      print(e.toString());
      throw "Can't get feedback";
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
      throw "Can't get last attempt assignment";
    }
  }

  Future<List<UserSubmited>> getListUserSubmit(
      String token, int assignInstanceId) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.MOD_ASSIGN_GET_LIST_PARTICIPANTS,
        "moodlewsrestformat": "json",
        'assignid': assignInstanceId,
        'groupid': 0,
        'filter': 0,
        'onlyids': 0,
      });
      if (res.data is Map<String, dynamic> && res.data["exception"] != null) {
        throw res.data["exception"];
      }
      final list = res.data as List;

      print(list);

      var listSubmited = list.map((e) => UserSubmited.fromJson(e)).toList();
      return listSubmited;
    } catch (e) {
      print(e.toString());
      throw "Can't get list submited user";
    }
  }

  Future<bool> saveGrade(
    String token,
    int assignInstanceId,
    int userid,
    double grade,
    String feedBackText,
  ) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.MOD_ASSIGN_SAVE_GRADE,
        "moodlewsrestformat": "json",
        'assignmentid': assignInstanceId,
        'userid': userid,
        'grade': grade,
        'attemptnumber': -1,
        'addattempt': 0,
        'applytoall': 0,
        'workflowstate': "grade",
        'plugindata[assignfeedbackcomments_editor][text]': feedBackText,
        'plugindata[assignfeedbackcomments_editor][format]': 0,
      });
      if (res.data is Map<String, dynamic> && res.data["exception"] != null) {
        throw res.data["exception"];
      }
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<AttemptAssignment> getAssignmentOfStudent(
      String token, int assignInstanceId, int userId) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.MOD_ASSIGN_GET_SUBMISSION_STATUS,
        "moodlewsrestformat": "json",
        'assignid': assignInstanceId,
        'userid': userId,
      });

      if (res.data["exception"] != null) {
        throw res.data["exception"];
      }
      final data = res.data['lastattempt'] as Map<String, dynamic>;
      AttemptAssignment temp = AttemptAssignment.fromJson(data);
      return temp;
    } catch (e) {
      print(e.toString());
      throw "Can't get last attempt assignment";
    }
  }

  Future<FeedBack> getAssignmentFeedbackAndGradeOfStudent(
      String token, int assignInstanceId, int userId) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.MOD_ASSIGN_GET_SUBMISSION_STATUS,
        "moodlewsrestformat": "json",
        'assignid': assignInstanceId,
        'userid': userId,
      });

      if (res.data["exception"] != null) {
        throw res.data["exception"];
      }
      if (res.data["feedback"] == null) {
        return FeedBack();
      }

      FeedBack feedback = FeedBack.fromJson(res.data["feedback"]);

      return feedback;
    } catch (e) {
      print(e.toString());
      throw "Can't get feedback";
    }
  }

  Future<Comment> getAssignmentComment(
      String token, int assignCmdId, int submissionId, int page) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.CORE_COMMENT_GET_COMMENTS,
        "moodlewsrestformat": "json",
        'contextlevel': "module",
        'instanceid': assignCmdId,
        "component": "assignsubmission_comments",
        "itemid": submissionId,
        "area": "submission_comments",
        "page": page,
      });

      if (res.data is Map<String, dynamic> && res.data["exception"] != null) {
        throw res.data["exception"];
      }

      Comment comment = Comment.fromJson(res.data);

      return comment;
    } catch (e) {
      print(e.toString());
      throw "Can't get comment";
    }
  }

  Future<bool> sendAssignmentComment(
      String token, int assignCmdId, int submissionId, String conttent) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.CORE_COMMENT_ADD_COMMENTS,
        "moodlewsrestformat": "json",
        'comments[0][contextlevel]': "module",
        'comments[0][instanceid]': assignCmdId,
        "comments[0][component]": "assignsubmission_comments",
        "comments[0][itemid]": submissionId,
        "comments[0][area]": "submission_comments",
        "comments[0][content]": conttent,
      });

      if (res.data is Map<String, dynamic> && res.data["exception"] != null) {
        throw res.data["exception"];
      }

      return true;
    } catch (e) {
      print(e.toString());
      throw "Can't send comment";
    }
  }
}
