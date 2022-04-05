import 'package:moodle_mobile/data/sharedpref/constant/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  // shared pref instance
  final SharedPreferences _sharedPreference;

  // constructor
  SharedPreferencesHelper(this._sharedPreference);

  //general methods:
  Future<String?> get authToken async {
    return _sharedPreference.getString(Preferences.auth_token);
  }

  Future<bool> saveAuthToken(String authToken) async {
    return _sharedPreference.setString(Preferences.auth_token, authToken);
  }

  String? get username {
    return _sharedPreference.getString(Preferences.username);
  }

  Future<bool> saveUsername(String username) async {
    return _sharedPreference.setString(Preferences.username, username);
  }
}
