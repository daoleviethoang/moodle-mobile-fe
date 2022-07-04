import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/data/network/apis/course/course_detail_service.dart';
import 'package:moodle_mobile/data/network/apis/grade/grade_service.dart';
import 'package:moodle_mobile/models/assignment/feedback.dart';
import 'package:moodle_mobile/models/course/course_detail.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/common/course/grade_overview.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moodle_mobile/view/grade_in_one_course.dart';

class CoursesGradeOverviewScreen extends StatefulWidget {
  const CoursesGradeOverviewScreen({
    Key? key,
  }) : super(key: key);

  @override
  _CoursesGradeOverviewScreenState createState() =>
      _CoursesGradeOverviewScreenState();
}

class _CoursesGradeOverviewScreenState extends State<CoursesGradeOverviewScreen>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  bool isLoad = false;
  List<Grade> grades = [];
  late UserStore _userStore;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();

    _userStore = GetIt.instance<UserStore>();
    getData();
  }

  getData() async {
    setState(() {
      isLoad = true;
    });
    List<Grade> grades;
    try {
      grades = await GradeService().getGrades(_userStore.user.token);
      setState(() {
        this.grades = grades;
        isLoad = false;
      });

      for (int i = 0; i < grades.length; i++) {
        CourseDetail courseDetail = await CourseDetailService()
            .getCourseById(_userStore.user.token, grades[i].courseid!);
        setState(() {
          grades[i].courseName = courseDetail.displayname!;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.grades),
      ),
      body: isLoad
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () => getData(),
              child: ListView(
                padding: const EdgeInsets.all(8),
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                children: List.generate(grades.length, (int index) {
                  final int count = grades.length;
                  final Animation<double> animation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animationController!,
                      curve: Interval((1 / count) * index, 1.0,
                          curve: Curves.fastOutSlowIn),
                    ),
                  );
                  animationController?.forward();
                  return GestureDetector(
                    onTap: () {
                      grades[index].courseName != null
                          ? Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) {
                                  return Scaffold(
                                    appBar: AppBar(
                                      title: Text(
                                          AppLocalizations.of(context)!.grade),
                                    ),
                                    body: GradeInOneCourse(
                                      courseId: grades[index].courseid!,
                                      courseName: grades[index].courseName,
                                    ),
                                  );
                                },
                              ),
                            )
                          : null;
                    },
                    child: GradeOverview(
                      courseId: grades[index].courseid!,
                      courseName: grades[index].courseName,
                      courseGrade: grades[index].grade,
                    ),
                  );
                }),
              ),
            ),
    );
  }
}
