import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moodle_mobile/data/firebase/constants/collections.dart';
import 'package:moodle_mobile/data/firebase/firebase_helper.dart';
import 'package:moodle_mobile/models/note/note.dart';
import 'package:moodle_mobile/models/note/notes.dart';

class NotesService {
  static FirebaseFirestore get _db => FirebaseHelper.db;

  static Future<Notes> getNotes(int uid) async {
    final col = await _db
        .collection(Collections.notes)
        .where('__name__',
            isGreaterThanOrEqualTo: '${uid}_', isLessThan: '$uid`')
        .get();
    final colOutput = col.docs.map((doc) {
      return Note.fromJson(doc.id, doc.data());
    }).toList();
    final noteValues = <Note>[];
    for (Note n in colOutput) {
      noteValues.add(n);
    }
    final notes = Notes(noteValues);
    return notes;
  }

  static Future<Note> getNoteById(String noteId) async {
    final doc = await _db.collection(Collections.notes).doc(noteId).get();
    return Note.fromJson(doc.id, doc.data() ?? {});
  }

  static Future<Note> setNote(Note note) async {
    await _db.collection(Collections.notes).doc(note.id).set(note.toJson());
    return note;
  }

  static Future deleteNote(Note note) async {
    await _db.collection(Collections.notes).doc(note.id).delete();
  }

  static Future<Note> toggleDone(Note note) async =>
      await setNote(note.copyWith(isDone: !note.isDone));

  static Future<Note> toggleImportant(Note note) async =>
      await setNote(note.copyWith(isImportant: !note.isImportant));

  static Future<Note> updateContent(Note note,
          {String? title, String? content}) async =>
      await setNote(note.copyWith(title: title, content: content));
}