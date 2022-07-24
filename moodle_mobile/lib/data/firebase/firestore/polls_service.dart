import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:moodle_mobile/data/firebase/constants/collections.dart';
import 'package:moodle_mobile/data/firebase/firebase_helper.dart';
import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/models/imgur/imgur_auth_token.dart';
import 'package:moodle_mobile/models/imgur/imgur_image.dart';
import 'package:moodle_mobile/models/imgur/imgur_token.dart';
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
}
