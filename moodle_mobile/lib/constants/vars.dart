import 'dart:io';

import 'package:flutter/foundation.dart';

class Vars {
  /// Return dart version number for this build
  /// (to be used for compatibility between different versions of Flutter)
  static double get dartVersion {
    // Flutter >= 3.0 uses Dart >= 2.17.0
    List<String> dartVersionNums = Platform.version.split(' ')[0].split('.');
    String dartVersionStr =
        dartVersionNums[0] + '.' + dartVersionNums.sublist(1).join();
    try {
      return double.parse(dartVersionStr);
    } catch (e) {
      if (kDebugMode) {
        print('!!!!!!!!!!$e');
      }
      return 0;
    }
  }

  /// Return whether the Flutter version for this build is >= 3.0
  static bool get isFlutter3Plus => Vars.dartVersion >= 2.17;
}