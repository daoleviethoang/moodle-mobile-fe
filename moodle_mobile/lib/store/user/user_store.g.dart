// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UserStore on _UserStore, Store {
  final _$userAtom = Atom(name: '_UserStore.user');

  @override
  UserModel get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(UserModel value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  final _$isLoginAtom = Atom(name: '_UserStore.isLogin');

  @override
  bool get isLogin {
    _$isLoginAtom.reportRead();
    return super.isLogin;
  }

  @override
  set isLogin(bool value) {
    _$isLoginAtom.reportWrite(value, super.isLogin, () {
      super.isLogin = value;
    });
  }

  final _$isLoadingAtom = Atom(name: '_UserStore.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  final _$isLoginFailedAtom = Atom(name: '_UserStore.isLoginFailed');

  @override
  bool get isLoginFailed {
    _$isLoginFailedAtom.reportRead();
    return super.isLoginFailed;
  }

  @override
  set isLoginFailed(bool value) {
    _$isLoginFailedAtom.reportWrite(value, super.isLoginFailed, () {
      super.isLoginFailed = value;
    });
  }

  final _$loginAsyncAction = AsyncAction('_UserStore.login');

  @override
  Future<dynamic> login(String username, String password) {
    return _$loginAsyncAction.run(() => super.login(username, password));
  }

  final _$_UserStoreActionController = ActionController(name: '_UserStore');

  @override
  void resetLoginFailed(bool value) {
    final _$actionInfo = _$_UserStoreActionController.startAction(
        name: '_UserStore.resetLoginFailed');
    try {
      return super.resetLoginFailed(value);
    } finally {
      _$_UserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void logout() {
    final _$actionInfo =
        _$_UserStoreActionController.startAction(name: '_UserStore.logout');
    try {
      return super.logout();
    } finally {
      _$_UserStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
user: ${user},
isLogin: ${isLogin},
isLoading: ${isLoading},
isLoginFailed: ${isLoginFailed}
    ''';
  }
}
