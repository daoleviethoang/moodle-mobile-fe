// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserStore on _UserStore, Store {
  late final _$userAtom = Atom(name: '_UserStore.user', context: context);

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

  late final _$isLoginAtom = Atom(name: '_UserStore.isLogin', context: context);

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

  late final _$isLoadingAtom =
      Atom(name: '_UserStore.isLoading', context: context);

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

  late final _$isLoginFailedAtom =
      Atom(name: '_UserStore.isLoginFailed', context: context);

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

  late final _$lastUpdatedAtom =
      Atom(name: '_UserStore.lastUpdated', context: context);

  @override
  int get lastUpdated {
    _$lastUpdatedAtom.reportRead();
    return super.lastUpdated;
  }

  @override
  set lastUpdated(int value) {
    _$lastUpdatedAtom.reportWrite(value, super.lastUpdated, () {
      super.lastUpdated = value;
    });
  }

  late final _$loginAsyncAction =
      AsyncAction('_UserStore.login', context: context);

  @override
  Future<dynamic> login(
      String username, String password, bool rememberAccount) {
    return _$loginAsyncAction
        .run(() => super.login(username, password, rememberAccount));
  }

  late final _$reGetUserInfoAsyncAction =
      AsyncAction('_UserStore.reGetUserInfo', context: context);

  @override
  Future<dynamic> reGetUserInfo(String token, String username) {
    return _$reGetUserInfoAsyncAction
        .run(() => super.reGetUserInfo(token, username));
  }

  late final _$setBaseUrlAsyncAction =
      AsyncAction('_UserStore.setBaseUrl', context: context);

  @override
  Future<dynamic> setBaseUrl(String baseUrl) {
    return _$setBaseUrlAsyncAction.run(() => super.setBaseUrl(baseUrl));
  }

  late final _$setUserAsyncAction =
      AsyncAction('_UserStore.setUser', context: context);

  @override
  Future<dynamic> setUser(String token, String username) {
    return _$setUserAsyncAction.run(() => super.setUser(token, username));
  }

  late final _$setLastUpdatedAsyncAction =
      AsyncAction('_UserStore.setLastUpdated', context: context);

  @override
  Future<dynamic> setLastUpdated(LastUpdateData lastUpdate) {
    return _$setLastUpdatedAsyncAction
        .run(() => super.setLastUpdated(lastUpdate));
  }

  late final _$_UserStoreActionController =
      ActionController(name: '_UserStore', context: context);

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
isLoginFailed: ${isLoginFailed},
lastUpdated: ${lastUpdated}
    ''';
  }
}
