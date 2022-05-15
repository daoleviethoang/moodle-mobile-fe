import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/data/shared_reference/shared_preference_helper.dart';
import 'package:moodle_mobile/di/service_locator.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Endpoints {
  Endpoints._();

  // base url
  static get baseUrl {
    SharedPreferenceHelper temp = getIt<SharedPreferenceHelper>();
    return temp.baseUrl ?? "";
  }

  // receiveTimeout
  static const int receiveTimeout = 15000;

  // connectTimeout
  static const int connectionTimeout = 30000;

  // Add more endpoints here when we need to call to different API
  // user endpoints
  static String login = baseUrl + "/login/token.php";
  static String webserviceServer = baseUrl + "/webservice/rest/server.php";
  static String uploadFile = baseUrl + "/webservice/upload.php";
}
