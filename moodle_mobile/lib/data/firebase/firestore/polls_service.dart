import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:moodle_mobile/data/firebase/constants/collections.dart';
import 'package:moodle_mobile/data/firebase/firebase_helper.dart';

import 'package:moodle_mobile/models/poll/poll.dart';

class PollService {
  static FirebaseFirestore get _db => FirebaseHelper.db;

  static const token = "2BCB05503397C356CF6518A17459346EA922D99F";

  static Future<Poll?> getPollByCouseId(String courseId) async {
    try {
      final doc = await _db.collection(Collections.polls).doc(courseId).get();
      print(doc.exists);
      if (!doc.exists) return null;
      final poll = Poll.fromJson(doc.data() ?? {});
      return poll;
    } catch (e) {
      print(e);
      return null;
    }
    //final doc = await _db.collection(Collections.polls).doc(courseId).get();

    // if (!doc.exists) return null;
    // final poll = Poll.fromJson(doc.data() ?? {});
    // return poll;
  }

  static Future setPoll(String courseId, Poll poll) async {
    final pollJson = poll.toJson()..addAll({'token': token});
    await _db.collection(Collections.polls).doc(courseId).set(pollJson);
  }

  static Future votePoll(String courseId, String userID, int optionId) async {
    Poll? temp = await getPollByCouseId(courseId);
    //Check old id
    final results = temp!.results ?? {};
    for (int i = 0; i < temp.options!.length; i++) {
      results['$i'] ??= [];
      results['$i']!.removeWhere((element) => element == userID);
    }
    //add new id
    results['$optionId']!.add(userID);
    //update new
    await _db.collection(Collections.polls).doc(courseId).update({
      'token': token,
      'results': results,
    });
  }

  static Future deletePoll(String courseId) async {
    await _db.collection(Collections.polls).doc(courseId).delete();
  }

  static Future updatePoll(
      String courseId, String subject, String content) async {
    await _db.collection(Collections.polls).doc(courseId).update({
      'token': token,
      'subject': subject,
      'content': content,
    });
  }

  static Future deleteVote(String courseId, String userID) async {
    Poll? temp = await getPollByCouseId(courseId);
    //Check old id
    final results = temp!.results ?? {};
    for (int i = 0; i < temp.options!.length; i++) {
      results['$i'] ??= [];
      results['$i']!.removeWhere((element) => element == userID);
    }
    //update new
    await _db.collection(Collections.polls).doc(courseId).update({
      'token': token,
      'results': results,
    });
  }
}