import 'package:moodle_mobile/models/contact/contact.dart';

class CourseOverview {
  CourseOverview(
      {required this.id,
      required this.title,
      this.isfavourite = false,
      this.hidden = false,
      this.startdate = 0,
      this.enddate = 0,
      this.lastaccess = 0,
      required this.teacher});

  int id;
  String title;
  bool isfavourite;
  bool hidden;
  int startdate;
  int enddate;
  int lastaccess;
  List<Contact> teacher;
}
