//import 'package:flutter/material.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';
import 'dart:async';
//import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/constants/wsfunction_constants.dart';
import 'package:moodle_mobile/models/course/course_participants.dart';

class CourseParticipants {
  Future<List<CourseParticipantsModel>> getParticipantInCourse(
    String token,
    int courseId,
  ) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.CORE_COURSES_PARTICIPANT,
        'moodlewsrestformat': 'json',
        'courseid': courseId,
        'options[0][name]': 'userfields',
        'options[0][value]': 'id,roles,profileimageurl,lastaccess'
      });

      List<CourseParticipantsModel> listCourseParticipants = [];
      for (var i = 0; i < (res.data as List).length; i++) {
        List<RoleOfParticitpants> listRoleParticipants = [];

        for (var j = 0; j < res.data[i]['roles'].length; j++) {
          listRoleParticipants.add(RoleOfParticitpants(
            roleID: res.data[i]['roles'][j]['roleid'],
          ));
        }

        listCourseParticipants.add(CourseParticipantsModel(
            id: res.data[i]['id'],
            fullname: res.data[i]['fullname'],
            roles: listRoleParticipants,
            lastAccess: res.data[i]['lastaccess'],
            avatar: res.data[i]['profileimageurl']));
      }
      return listCourseParticipants;
    } catch (e) {
      rethrow;
    }
  }
}
