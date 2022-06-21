import 'dart:io';

import 'package:flutter/foundation.dart';

class Vars {
  /// The time waiting before calling refresh data again
  static const Duration refreshInterval = Duration(seconds: 5);

  /// Get app info
  // static Future<PackageInfo> get packageInfo => PackageInfo.fromPlatform();

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

  /// How much time is `recent` for notes
  static const Duration recentThreshold = Duration(days: 7);
}