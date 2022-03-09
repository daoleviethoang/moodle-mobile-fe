import 'package:moodle_mobile/data/network/apis/user/user_api.dart';
import 'package:moodle_mobile/models/user.dart';

class Repository {
  final UserApi _userApi;

  // Constructor
  Repository(this._userApi);

  // User Login
  Future<String> login(String username, String password, String service) =>
      _userApi.login(username, password, service);

  Future<UserModel> getUserInfo(String token, String username) =>
      _userApi.getUserInfo(token, username);
}
