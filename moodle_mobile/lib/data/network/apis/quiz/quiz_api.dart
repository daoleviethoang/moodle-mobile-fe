import 'dart:async';

import 'package:dio/dio.dart';
import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/constants/wsfunction_constants.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';
import 'package:moodle_mobile/models/quiz/attempt.dart';
import 'package:moodle_mobile/models/quiz/quiz.dart';
import 'package:moodle_mobile/models/quiz/quizData.dart';

class QuizApi {
  Future<List<Quiz>> getQuizs(String token, int courseId) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.MOD_QUIZ_GET_QUIZZES_BY_COURSES,
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

  Future<List<Attempt>> getAttempts(
      String token, int quizId, int? userId) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.MOD_QUIZ_GET_USER_ATTEMPTS,
        'moodlewsrestformat': 'json',
        'quizid': quizId,
        'status': "all",
        'includepreviews': 1,
        'userid': userId ??
            0, // null return attempt of owner else return attempt of user id
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

  Future<Attempt> startQuiz(String token, int quizId) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.MOD_QUIZ_START_ATTEMPT,
        'moodlewsrestformat': 'json',
        'quizid': quizId,
      });

      if (res.data["exception"] != null) {
        throw res.data["exception"];
      }
      return Attempt.fromJson(res.data["attempt"]);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> endQuiz(String token, int attemptid) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.MOD_QUIZ_PROCESS_ATTEMPT,
        'moodlewsrestformat': 'json',
        'attemptid': attemptid,
        'finishattempt': 1,
      });

      if (res.data["exception"] != null) {
        throw res.data["exception"];
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<QuizData> getDoQuizData(String token, int attemptid) async {
    QuizData? quizData;
    try {
      Dio dio = Http().client;
      int page = 0;

      while (true) {
        final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
          'wstoken': token,
          'wsfunction': Wsfunction.MOD_QUIZ_GET_ATTEMPT_DATA,
          'moodlewsrestformat': 'json',
          'attemptid': attemptid,
          'page': page
        });

        if (res.data["exception"] != null) {
          throw res.data["exception"];
        }
        if (quizData == null) {
          quizData = QuizData.fromJson(res.data);
          if (quizData.nextpage == -1) {
            break;
          }
        } else {
          var temp = QuizData.fromJson(res.data);
          quizData.questions!.addAll(temp.questions ?? []);
          if (temp.nextpage == -1) {
            break;
          }
        }
        page++;
      }

      return quizData;
    } catch (e) {
      rethrow;
    }
  }

  saveQuizData(String token, int attemptid, List<String> keys,
      List<String> values) async {
    try {
      Dio dio = Http().client;
      var map = {
        'wstoken': token,
        'wsfunction': Wsfunction.MOD_QUIZ_PROCESS_ATTEMPT,
        'moodlewsrestformat': 'json',
        'attemptid': attemptid,
      };
      for (int i = 0; i < keys.length; i++) {
        if (keys[i] != "") {
          map.addAll({
            'data[$i][name]': keys[i],
            'data[$i][value]': values[i],
          });
        }
      }

      final res =
          await dio.get(Endpoints.webserviceServer, queryParameters: map);

      if (res.data is Map<String, dynamic> && res.data["exception"] != null) {
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
        'wsfunction': Wsfunction.MOD_QUIZ_GET_ATTEMPT_REVIEW,
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
        'wsfunction': Wsfunction.MOD_QUIZ_GET_USER_BEST_GRADE,
        'moodlewsrestformat': 'json',
        'quizid': quizId,
      });
      if (res.data is Map<String, dynamic> && res.data["exception"] != null) {
        throw res.data["exception"];
      }
      if (res.data["hasgrade"] == false) {
        return null;
      }
      return double.parse(res.data["grade"].toString());
    } catch (e) {
      throw "Can't get grade of quiz $quizId";
    }
  }
}
