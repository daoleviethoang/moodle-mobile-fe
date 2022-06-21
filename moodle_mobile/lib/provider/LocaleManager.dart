import 'package:flutter/material.dart';
import 'StorageManager.dart';

class LocaleNotifier with ChangeNotifier {
  final localeUS = const Locale('en', 'US');

  final localeVN = const Locale('vi', 'VN');

  late Locale? _localData;
  Locale? getLocale() => _localData;

  LocaleNotifier() {
    StorageManager.readData('localeMode').then((value) {
      var localeMode = value ?? 'default';

      if (localeMode == 'default') {
        _localData = null;
        notifyListeners();
        return;
      }

      if (localeMode == 'en') {
        _localData = localeUS;
      } else {
        _localData = localeVN;
      }
      notifyListeners();
    });
  }

  void setMode(String value) async {
    if (value == 'default') {
      _localData = null;
      StorageManager.saveData('localeMode', 'default');
      notifyListeners();
      return;
    }
    if (value == "en") {
      _localData = localeUS;
      StorageManager.saveData('localeMode', 'en');
      notifyListeners();
    } else {
      _localData = localeVN;
      StorageManager.saveData('localeMode', 'vi');
      notifyListeners();
    }
  }
}
