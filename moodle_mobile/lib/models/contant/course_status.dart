import 'package:moodle_mobile/models/contant/contant_model.dart';

enum CourseStatus {
  in_progress,
  future,
  past,
  removed_from_view,
  all_expand,
  all
}

extension CourseStatusExtension on CourseStatus {
  String get name {
    switch (this) {
      case CourseStatus.in_progress:
        return 'In progress';
      case CourseStatus.future:
        return 'Future';
      case CourseStatus.past:
        return 'Past';
      case CourseStatus.removed_from_view:
        return 'Removed from view';
      case CourseStatus.all_expand:
        return 'All (except remove from view)';
      case CourseStatus.all:
        return 'All';
      default:
        return '';
    }
  }
}
