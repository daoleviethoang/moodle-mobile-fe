import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:moodle_mobile/data/firebase/constants/collections.dart';
import 'package:moodle_mobile/data/firebase/firebase_helper.dart';

import 'package:moodle_mobile/models/poll/poll.dart';

class PollService {
  static FirebaseFirestore get _db => FirebaseHelper.db;

  static Future<Poll?> getPollByCouseId(String courseId) async {
    final doc = await _db.collection(Collections.polls).doc(courseId).get();
    if (!doc.exists) return null;
    final poll = Poll.fromJson(doc.data() ?? {});
    return poll;
  }

  static Future setPoll(String courseId, Poll poll) async {
    await _db.collection(Collections.polls).doc(courseId).set(poll.toJson());
    print('test2');
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
    await _db
        .collection(Collections.polls)
        .doc(courseId)
        .update({'results': results});
  }

  static Future deletePoll(String courseId) async {
    await _db.collection(Collections.polls).doc(courseId).delete();
  }
}
