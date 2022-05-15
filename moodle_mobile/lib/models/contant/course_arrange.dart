import 'package:moodle_mobile/models/contant/contant_model.dart';

enum CourseArrange { name, last_accessed }

extension CourseStatusExtension on CourseArrange {
  String get name {
    switch (this) {
      case CourseArrange.name:
        return 'Course name';
      case CourseArrange.last_accessed:
        return 'Last accessed';
      default:
        return '';
    }
  }
}
