import 'package:dio/dio.dart';
import 'package:moodle_mobile/data/network/apis/course/course_service.dart';
import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/network/constants/wsfunction_constants.dart';
import 'package:moodle_mobile/data/network/dio_http.dart';
import 'package:moodle_mobile/models/course/course.dart';
import 'package:moodle_mobile/models/note/note.dart';
import 'package:moodle_mobile/models/note/notes.dart';

class NotesService {
  Future<Notes> getCourseNotes(String token, int cid,
      [String? courseName]) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.GET_COURSE_NOTES,
        'moodlewsrestformat': 'json',
        'courseid': cid,
      });

      var json = res.data as Map<String, dynamic>;
      var data = (json['personalnotes'] as List<dynamic>?) ?? [];

      final mapList = <Map<String, dynamic>>[];
      for (var d in data) {
        mapList.add(d as Map<String, dynamic>);
      }
      final notes = Notes(mapList.map((n) {
        var note = Note.fromJson(n);
        if (courseName != null) {
          note.courseName = courseName;
        }
        return note;
      }).toList());
      return notes;
    } catch (e) {
      rethrow;
    }
  }

  Future<Notes> getNotes(String token, int uid) async {
    try {
      final courses = await CourseService().getCourses(token, uid);
      final notes = Notes([]);
      for (Course course in courses) {
        final courseNotes =
            await getCourseNotes(token, course.id, course.displayname);
        notes.values?.addAll(courseNotes.values ?? []);
      }
      return notes;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> createNote(String token, Note note) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.CREATE_NOTES,
        'moodlewsrestformat': 'json',
        'notes': [
          {
            'userid': note.userid,
            'publishstate': note.publishstate,
            'courseid': note.courseid,
            'text': note.text,
            'format': note.format,
          }
        ],
      });

      return res.data[0]['noteid'] as int;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> updateNote(String token, Note note) async {
    try {
      Dio dio = Http().client;
      final res = await dio.get(Endpoints.webserviceServer, queryParameters: {
        'wstoken': token,
        'wsfunction': Wsfunction.UPDATE_NOTES,
        'moodlewsrestformat': 'json',
        'notes': [
          {
            'id': note.noteid,
            'publishstate': note.publishstate,
            'text': note.text,
            'format': note.format,
          }
        ],
      });

      return note.noteid!;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> setNote(String token, Note note) async {
    try {
      if (note.noteid == null) {
        return await createNote(token, note);
      } else {
        return await updateNote(token, note);
      }
    } catch (e) {
      rethrow;
    }
  }
}