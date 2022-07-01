import 'package:moodle_mobile/data/shared_reference/shared_preference_helper.dart';
import 'package:moodle_mobile/di/service_locator.dart';

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
  static String forgetPass = baseUrl + "/lib/ajax/service-nologin.php";
  static get webserviceServer {
    return baseUrl + "/webservice/rest/server.php";
  }

  static String uploadFile = baseUrl + "/webservice/upload.php";
}
