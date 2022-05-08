import 'package:moodle_mobile/models/contant/course_arrange.dart';
import 'package:moodle_mobile/models/contant/course_status.dart';

class ContantModel {
  var key;
  String value;

  ContantModel({required this.key, required this.value});
}

extension ContantExtension on ContantModel {
  static List<ContantModel> get allCourseArrange {
    List<ContantModel> list = [];
    for (var value in CourseArrange.values) {
      ContantModel courseStatusModel =
          ContantModel(key: value, value: value.name);
      list.add(courseStatusModel);
    }
    return list;
  }

  static List<ContantModel> get allCourseStatus {
    List<ContantModel> list = [];
    for (var value in CourseStatus.values) {
      ContantModel courseStatusModel =
          ContantModel(key: value, value: value.name);
      if (value == CourseStatus.all) continue;
      list.add(courseStatusModel);
    }
    return list;
  }

  static ContantModel get CourseStatusSelected {
    return ContantModel(key: CourseStatus.all, value: CourseStatus.all.name);
  }

  static ContantModel get CourseArrangeSelected {
    return ContantModel(
        key: CourseArrange.name, value: CourseArrange.name.name);
  }
}
