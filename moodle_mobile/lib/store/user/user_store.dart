import 'package:mobx/mobx.dart';
import 'package:moodle_mobile/data/repository.dart';

// Include generated file
part 'user_store.g.dart';

// This is the class used by rest of your codebase
class UserStore = _UserStore with _$UserStore;

// The store-class
abstract class _UserStore with Store {
  // Repository
  final Repository _repository;

  // Constructor
  _UserStore(this._repository);

  @observable
  bool isLogin = false;

  @action
  Future login(String username, String password) async {
    String res =
        await _repository.login(username, password, 'moodle_mobile_app');

    print(res);

    isLogin = true;
  }

  @action
  void logout() {
    isLogin = false;
  }
}
