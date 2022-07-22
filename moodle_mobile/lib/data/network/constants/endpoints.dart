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
  static get login => "$baseUrl/login/token.php";

  static get forgetPass => "$baseUrl/lib/ajax/service-nologin.php";

  static get webserviceServer => "$baseUrl/webservice/rest/server.php";

  static get uploadFile => "$baseUrl/webservice/upload.php";

  static const imgurServer = 'https://api.imgur.com';
  static const imgurGenerateToken = '$imgurServer/oauth2/token';
  static const imgurUploadImage = '$imgurServer/3/image';
}