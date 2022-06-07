import 'package:firebase_core/firebase_core.dart';
import 'package:moodle_mobile/firebase_options.dart';

import 'messaging/messaging_helper.dart';

class FirebaseHelper {
  static Future initFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    MessagingHelper.initMessaging();
  }
}