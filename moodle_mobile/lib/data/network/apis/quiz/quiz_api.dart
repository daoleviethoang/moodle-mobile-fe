import 'dart:async';

import 'package:dio/dio.dart';
import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';
import 'package:moodle_mobile/models/quiz/attempt.dart';
import 'package:moodle_mobile/models/quiz/question.dart';
import 'package:moodle_mobile/models/quiz/quiz.dart';
import 'package:moodle_mobile/models/quiz/quizData.dart';

class QuizApi {
  Future<List<Quiz>> getQuizs(String token, int courseId) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': 'mod_quiz_get_quizzes_by_courses',
        'moodlewsrestformat': 'json',
        'courseids[]': [courseId]
      });
      if (res.data["exception"] != null) {
        throw res.data["exception"];
      }

      var list = res.data["quizzes"] as List;
      return list.map((e) => Quiz.fromJson(e)).toList();
    } catch (e) {
      throw "Can't get list quiz";
    }
  }

  Future<List<Attempt>> getAttempts(String token, int quizId) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': 'mod_quiz_get_user_attempts',
        'moodlewsrestformat': 'json',
        'quizid': quizId,
        'includepreviews': 1,
      });
      if (res.data["exception"] != null) {
        throw res.data["exception"];
      }
      var list = res.data["attempts"] as List;
      return list.map((e) => Attempt.fromJson(e)).toList();
    } catch (e) {
      throw "Can't get attempt of quiz $quizId";
    }
  }

  Future<QuizData> getDoQuizData(String token, int attemptid, int page) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': 'mod_quiz_get_attempt_data',
        'moodlewsrestformat': 'json',
        'attemptid': attemptid,
        'page': page
      });
      if (res.data["exception"] != null) {
        throw res.data["exception"];
      }
      return QuizData.fromJson(res.data);
    } catch (e) {
      rethrow;
    }
  }

  saveQuizData(String token, int attemptid, List<String> keys,
      List<String> values) async {
    try {
      Dio dio = Http().client;
      List list = [];
      for (int i = 0; i < keys.length; i++) {
        list.add({"name": keys[i], "value": values[i]});
      }
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': 'mod_quiz_get_attempt_data',
        'moodlewsrestformat': 'json',
        'attemptid': attemptid,
        'data': list,
      });
      if (res.data["exception"] != null) {
        throw res.data["exception"];
      }
      return QuizData.fromJson(res.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<QuizData> getPreviewQuiz(String token, int attemptid) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': 'mod_quiz_get_attempt_review',
        'moodlewsrestformat': 'json',
        'attemptid': attemptid,
      });
      if (res.data["exception"] != null) {
        throw res.data["exception"];
      }
      return QuizData.fromJson(res.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<double?> getGrade(String token, int quizId) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': 'mod_quiz_get_user_best_grade',
        'moodlewsrestformat': 'json',
        'quizid': quizId,
      });
      if (res.data["exception"] != null) {
        throw res.data["exception"];
      }
      if (res.data["hasgrade"] == false) {
        return null;
      }
      return res.data["grade"];
    } catch (e) {
      throw "Can't get grade of quiz $quizId";
    }
  }
}
