import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:moodle_mobile/data/shared_reference/constants/preferences.dart';
import 'package:moodle_mobile/models/Discussion.dart';
import 'package:moodle_mobile/models/forum.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForumManager {
  static Future<List<Discussion>> fetchDicussion(String forumID) async {
    List<Discussion> temp = [];
    //Get token
    final prefs = await SharedPreferences.getInstance();
    final tokens = prefs.getString(Preferences.auth_token);
    final res = await http.get(Uri.parse(
        'https://courses.ctda.hcmus.edu.vn/webservice/rest/server.php?wstoken=' +
            tokens! +
            '&wsfunction=mod_forum_get_forum_discussions&moodlewsrestformat=json&forumid=' +
            forumID));
    final resJson = jsonDecode(res.body)['discussions'];
    for (var t in resJson) {
      temp.add(Discussion.fromJson(t));
    }
    return temp;
  }

  static void subscrible(String forumID,String discussionID) async
  {
    final prefs = await SharedPreferences.getInstance();
    final tokens = prefs.getString(Preferences.auth_token);
    final res = await http.get(Uri.parse('https://courses.ctda.hcmus.edu.vn/webservice/rest/server.php?wstoken=16f42d6282ed887c73d46d12813981e3&wsfunction=mod_forum_set_subscription_state&moodlewsrestformat=json&forumid=2964&targetstate=1&discussionid'))
  }
}
