import 'package:mobx/mobx.dart';
import 'package:moodle_mobile/data/repository.dart';
import 'package:moodle_mobile/models/user.dart';

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
  UserModel user =
      UserModel(token: "", id: 0, username: "", fullname: "", email: "");

  @observable
  bool isLogin = false;

  @observable
  bool isLoginFailed = false;

  @action
  Future login(String username, String password) async {
    try {
      String token =
          await _repository.login(username, password, 'moodle_mobile_app');
      user = await _repository.getUserInfo(token, username);
      isLogin = true;
    } catch (e) {
      print("Login error: " + e.toString());
      isLoginFailed = true;
      isLogin = false;
    }
  }

  @action
  void resetLoginFailed(bool value) {
    isLoginFailed = false;
  }

  @action
  void logout() {
    isLogin = false;
  }
}
