import 'dart:async';

import 'package:moodle_mobile/data/shared_reference/constants/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  // shared pref instance
  final SharedPreferences _sharedPreference;

  // constructor
  SharedPreferenceHelper(this._sharedPreference);

  // General Methods: ----------------------------------------------------------
  String? get authToken {
    return _sharedPreference.getString(Preferences.auth_token);
  }

  Future<bool> saveAuthToken(String authToken) async {
    return _sharedPreference.setString(Preferences.auth_token, authToken);
  }

  Future<bool> removeAuthToken() async {
    return _sharedPreference.remove(Preferences.auth_token);
  }

  String? get username {
    return _sharedPreference.getString(Preferences.username);
  }

  Future<bool> saveUsername(String username) async {
    return _sharedPreference.setString(Preferences.username, username);
  }

  String? get baseUrl {
    return _sharedPreference.getString(Preferences.base_url);
  }

  Future<bool> saveBaseUrl(String baseUrl) async {
    return _sharedPreference.setString(Preferences.base_url, baseUrl);
  }
}