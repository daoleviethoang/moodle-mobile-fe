import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
//import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/data/repository.dart';
import 'package:moodle_mobile/models/notification/last_updated_data.dart';
import 'package:moodle_mobile/models/user.dart';
import 'package:moodle_mobile/models/user_login.dart';
import 'package:moodle_mobile/sqllite/sql.dart';

// Include generated file
part 'user_store.g.dart';

// This is the class used by rest of your codebase
class UserStore = _UserStore with _$UserStore;

// The store-class
abstract class _UserStore with Store {
  // Repository
  final Repository _repository;

  // Disposers
  late ReactionDisposer _loginFailedDisposer;

  // Constructor
  _UserStore(this._repository) {
    _loginFailedDisposer =
        reaction((_) => isLoginFailed, resetLoginFailed, delay: 2000);
  }

  @observable
  UserModel user = UserModel(
      token: "", id: 0, username: "", fullname: "", email: "", baseUrl: "");

  @observable
  bool isLogin = false;

  @observable
  bool isLoading = false;

  @observable
  bool isLoginFailed = false;

  @observable
  int lastUpdated = 0;

  @action
  Future login(String username, String password, bool rememberAccount) async {
    try {
      String token =
          await _repository.login(username, password, 'moodle_mobile_app');
      user = await _repository.getUserInfo(token, username);
      if (kDebugMode) print("here userstore");

      if (rememberAccount) {
        // Save to shared references
        _repository.saveAuthToken(token);
        _repository.saveUsername(username);
      }

      //need save to list userlogin success
      if (rememberAccount) {
        SQLHelper.createUserItem(UserLogin(
          token: token,
          baseUrl: _repository.baseUrl ?? "",
          username: username,
          photo: user.photo,
        ));
      }

      isLogin = true;
    } catch (e) {
      if (kDebugMode) print("Login error: $e");
      isLoginFailed = true;
      isLogin = false;
    }
  }

  @action
  Future reGetUserInfo(String token, String username) async {
    try {
      if (kDebugMode) print("setUserStore");
      user = await _repository.getUserInfo(token, username);
    } catch (e) {
      if (kDebugMode) print("re get user info error: $e");
    }
  }

  @action
  Future setBaseUrl(String baseUrl) async {
    try {
      _repository.saveBaseUrl(baseUrl);
    } catch (e) {
      if (kDebugMode) print("Save baseurl error: $e");
    }
  }

  Future checkIsLogin() async {
    try {
      isLoading = true;

      String? token = _repository.authToken;
      String? username = _repository.username;
      String? baseUrl = _repository.baseUrl;

      if (token == null || token == "" || username == null || baseUrl == null) {
        isLogin = false;
        isLoading = false;
        return;
      }

      user = await _repository.getUserInfo(token, username);
      isLogin = true;
      isLoading = false;
    } catch (e) {
      if (kDebugMode) print("Check is login error: $e");
      isLogin = false;
      isLoading = false;
    }
  }

  @action
  void resetLoginFailed(bool value) {
    isLoginFailed = false;
  }

  @action
  Future setUser(String token, String username) async {
    try {
      isLoading = true;

      _repository.saveAuthToken(token);
      _repository.saveUsername(username);

      user = await _repository.getUserInfo(token, username);

      if (kDebugMode) {
        print(user.fullname);
        print("here userstore");
      }

      isLogin = true;
      isLoading = false;
    } catch (e) {
      if (kDebugMode) print("Set user error: $e");
      isLoginFailed = true;
      isLogin = false;
      isLoading = false;
    }
  }

  @action
  Future setLastUpdated(LastUpdateData lastUpdate) async {
    try {
      _repository.saveLastUpdated('$lastUpdated');
    } catch (e) {
      if (kDebugMode) print("Set last updated error: $e");
    }
  }

  @action
  void logout() {
    _repository.saveAuthToken("");
    _repository.saveUsername("");
    _repository.saveBaseUrl("");
    isLogin = false;
  }
}
