class Course {
  Course(
      {this.id = 0, this.title = '', this.teacher = const [], this.tag = ''});

  int id;
  String title;
  List<String> teacher;
  String tag;

  static List<Course> popularCourseList = <Course>[
    Course(
      title: 'Quản trị cơ sở dữ liệu hiện đại',
      teacher: ['Nguyen Van A', 'Nguyen Van A', 'Nguyen Van A'],
      tag: '18HTTT',
    ),
    Course(
      title: 'Quản trị cơ sở dữ liệu hiện đại',
      teacher: ['Nguyen Van A', 'Nguyen Van A', 'Nguyen Van A'],
      tag: '18HTTT',
    ),
    Course(
      title: 'Quản trị cơ sở dữ liệu hiện đại',
      teacher: ['Nguyen Van A', 'Nguyen Van A', 'Nguyen Van A'],
      tag: '18HTTT',
    ),
    Course(
      title: 'Quản trị cơ sở dữ liệu hiện đại',
      teacher: ['Nguyen Van A', 'Nguyen Van A', 'Nguyen Van A'],
      tag: '18HTTT',
    ),
  ];
}
