import 'package:moodle_mobile/models/contact/contact.dart';

class CourseOverview {
  CourseOverview({required this.id, this.title = '', required this.teacher});

  int id;
  String? title;
  List<Contact> teacher;
}
