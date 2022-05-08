import 'package:moodle_mobile/models/contant/contant_model.dart';

enum CourseArrange { name, future }

extension CourseStatusExtension on CourseArrange {
  String get name {
    switch (this) {
      case CourseArrange.name:
        return 'Course name';
      case CourseArrange.future:
        return 'Future';
      default:
        return '';
    }
  }

  List<ContantModel> get all {
    List<ContantModel> list = [];
    for (var value in CourseArrange.values) {
      ContantModel courseStatusModel =
          ContantModel(key: value, value: value.name);
      list.add(courseStatusModel);
    }
    return list;
  }
}
