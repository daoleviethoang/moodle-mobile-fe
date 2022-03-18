import 'package:moodle_mobile/data/network/apis/user/user_api.dart';

class Repository {
  final UserApi _userApi;

  // Constructor
  Repository(this._userApi);

  // User Login
  Future<String> login(String username, String password, String service) =>
      _userApi.login(username, password, service);
}
