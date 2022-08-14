enum CourseArrange { name, last_accessed, default_ }

extension CourseStatusExtension on CourseArrange {
  String get name {
    switch (this) {
      case CourseArrange.name:
        return 'Course name';
      case CourseArrange.last_accessed:
        return 'Last accessed';
      case CourseArrange.default_:
        return 'Default';
      default:
        return '';
    }
  }
}