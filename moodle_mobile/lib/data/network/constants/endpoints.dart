class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl = "https://courses.ctda.hcmus.edu.vn";

  // receiveTimeout
  static const int receiveTimeout = 15000;

  // connectTimeout
  static const int connectionTimeout = 30000;

  // Add more endpoints here when we need to call to different API
  // user endpoints
  static const String login = baseUrl + "/login/token.php";
  static const String userInfo = baseUrl + "/webservice/rest/server.php";
}
