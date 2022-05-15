import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/styles.dart';
import 'package:moodle_mobile/data/network/apis/calendar/calendar_service.dart';
import 'package:moodle_mobile/data/network/apis/course/course_content_service.dart';
import 'package:moodle_mobile/data/network/apis/course/course_detail_service.dart';
import 'package:moodle_mobile/data/network/apis/module/module_service.dart';
import 'package:moodle_mobile/models/calendar/event.dart';
import 'package:moodle_mobile/models/course/course_content.dart';
import 'package:moodle_mobile/models/course/course_detail.dart';
import 'package:moodle_mobile/models/module/module.dart';
import 'package:moodle_mobile/models/module/module_course.dart';
import 'package:moodle_mobile/view/common/content_item.dart';
import 'package:moodle_mobile/view/common/data_card.dart';
import 'package:moodle_mobile/view/common/image_view.dart';
import 'package:moodle_mobile/view/common/menu_item.dart' as m;
import 'package:moodle_mobile/view/enrol/enrol.dart';
import 'package:moodle_mobile/view/forum/forum_screen.dart';
import 'package:moodle_mobile/view/grade_in_one_course.dart';
import 'package:moodle_mobile/view/user_detail/user_detail.dart';
import 'package:moodle_mobile/view/user_detail/user_detail_student.dart';
import 'package:moodle_mobile/store/user/user_store.dart';

class CourseDetailsScreen extends StatefulWidget {
  final int courseId;

  const CourseDetailsScreen({Key? key, required this.courseId})
      : super(key: key);

  @override
  _CourseDetailsScreenState createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late var _tabs = <Widget>[];
  var _index = 0;
  late var _body = <Widget>[];
  Widget _homeTab = Container();
  Widget _announcementsTab = Container();
  Widget _discussionsTab = Container();
  Widget _upcomingTab = Container();
  Widget _gradesTab = Container();
  Widget _peopleTab = Container();

  late int _courseId;
  late UserStore _userStore;
  CourseDetail? _course;
  List<CourseContent> _content = [];
  List<Event> _upcoming = [];

  @override
  void initState() {
    super.initState();
    _courseId = widget.courseId;
    _userStore = GetIt.instance<UserStore>();
  }

  // region BODY

  void _initBody() {
    _initTabList();
    _initHomeTab();
    _initAnnouncementsTab();
    _initDiscussionsTab();
    _initUpcomingTab();
    _initGradesTab();
    _initPeopleTab();

    _body = [
      _homeTab,
      _announcementsTab,
      _discussionsTab,
      _upcomingTab,
      _gradesTab,
      _peopleTab,
    ];
  }

  void _initTabList() {
    _tabs = [
      const Tab(child: Text('Home')),
      const Tab(child: Text('Announcements')),
      const Tab(child: Text('Discussion Forums')),
      const Tab(child: Text('Events')),
      const Tab(child: Text('Grades')),
      const Tab(child: Text('Participants')),
    ];
    _tabController = TabController(
      length: _tabs.length,
      initialIndex: _index,
      vsync: this,
    );
  }

  void _initHomeTab() {
    _homeTab = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _content.map((c) {
        return SectionItem(
          header: HeaderItem(text: c.name),
          body: c.modules.map((m) {
            try {
              final title = m.name ?? '';
              switch (m.modname ?? '') {
                case ModuleName.assign:
                  final ms = jsonDecode(m.customdata ?? '')['duedate'];
                  final dueDate = (ms != null)
                      ? DateTime.fromMillisecondsSinceEpoch(
                          jsonDecode(m.customdata ?? '')['duedate'] * 1000)
                      : null;
                  return SubmissionItem(
                    title: title,
                    submissionId: m.instance ?? 0,
                    courseId: widget.courseId,
                    dueDate: dueDate,
                  );
                case ModuleName.chat:
                  return ChatItem(
                    title: title,
                    onPressed: () {},
                  );
                case ModuleName.folder:
                  return Container();
                case ModuleName.forum:
                  return ForumItem(
                    title: title,
                    onPressed: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      //   return ForumScreen();
                      // })))
                    },
                  );
                case ModuleName.label:
                  return RichTextCard(text: m.description ?? '');
                case ModuleName.page:
                  return PageItem(
                    title: title,
                    onPressed: () {},
                  );
                case ModuleName.quiz:
                  return QuizItem(
                      title: title,
                      quizInstanceId: m.instance ?? 0,
                      courseId: widget.courseId);
                case ModuleName.resource:
                  var url = m.contents?[0].fileurl ?? '';
                  if (url.isNotEmpty) {
                    url = url.substring(0, url.indexOf('?forcedownload'));
                    url += '?token=' + _userStore.user.token;
                  }
                  return DocumentItem(
                    title: title,
                    documentUrl: url,
                  );
                case ModuleName.url:
                  return UrlItem(
                    title: title,
                    url: m.contents?[0].fileurl ?? '',
                  );
                case ModuleName.zoom:
                  return Container();
                default:
                  print('$m');
                  return ErrorCard(text: 'Unknown module name: ${m.modname}');
              }
            } catch (e) {
              // FIXME: Assignment text is [] instead of string
              print('$m');
              return ErrorCard(text: '$e');
            }
          }).toList(),
        );
      }).toList(),
    );
  }

  void _initAnnouncementsTab() {
    // TODO: Parse module from API
    _announcementsTab = const Center(child: Text('Announcements'));
  }

  void _initDiscussionsTab() {
    if (_content.isEmpty) {
      _discussionsTab = ForumScreen(forumId: 0);
    } else {
      _discussionsTab = ForumScreen(
        forumId: _content[0].modules[1].instance ?? 0,
        courseId: _courseId,
      );
    }
  }

  void _initUpcomingTab() {
    _upcomingTab = Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Upcoming events', style: MoodleStyles.courseHeaderStyle),
          Container(height: 16),
          ..._upcoming.map((e) {
            final title = e.name ?? '';
            final epoch = (e.timestart ?? 0) * 1000;
            final dueDate = DateTime.fromMillisecondsSinceEpoch(epoch);
            switch (e.modulename ?? '') {
              case ModuleName.assign:
                return FutureBuilder(
                    future: queryModule(e),
                    builder: (context, data) {
                      if (data.hasError) {
                        return ErrorCard(text: '${data.error}');
                      } else if (!data.hasData) {
                        return const LoadingCard();
                      }
                      final instance =
                          (data.data as ModuleCourse).instance ?? 0;
                      return SubmissionItem(
                        title: title,
                        submissionId: instance,
                        courseId: e.course?.id ?? 0,
                        dueDate: dueDate,
                      );
                    });
              case ModuleName.quiz:
                return FutureBuilder(
                    future: queryModule(e),
                    builder: (context, data) {
                      if (data.hasError) {
                        return ErrorCard(text: '${data.error}');
                      } else if (!data.hasData) {
                        return const LoadingCard();
                      }
                      final instance =
                          (data.data as ModuleCourse).instance ?? 0;
                      return QuizItem(
                        title: title,
                        openDate: dueDate,
                        quizInstanceId: instance,
                        courseId: e.course?.id ?? 0,
                      );
                    });
              default:
                throw Exception('Unknown module name: ' + (e.modulename ?? ''));
            }
          }).toList(),
        ],
      ),
    );
  }

  void _initGradesTab() {
    _gradesTab = const GradeInOneCourse();
  }

  void _initPeopleTab() {
    // TODO: Get participant list from API
    final participants = [
      'Lâm Quang Vũ',
      'Nguyễn Gia Hưng',
      'Ngô Thị Thanh Theo',
      'Hà Thế Hiển',
      'Đào Lê Việt Hoàng',
      'Trần Đình Phát',
    ];

    // Return People list section
    _peopleTab = SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('People in this course',
              style: MoodleStyles.courseHeaderStyle),
          Container(height: 16),
          ...List.generate(participants.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: m.MenuItem(
                image: const RoundedImageView(
                  imageUrl: 'user-avatar-url',
                  placeholder: Icon(Icons.person, size: 48),
                ),
                title: participants[index],
                subtitle: 'Student',
                onPressed: () => {
                  if (index == 0)
                    {
                      Navigator.push<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) => UserDetailsScreen(
                            avatar:
                                'https://meta.vn/Data/image/2021/08/17/con-vit-vang-tren-fb-la-gi-trend-anh-avatar-con-vit-vang-la-gi-3.jpg',
                            role: 'Teacher',
                            course: 'Đồ án tốt nghiệp',
                            email: 'lqvu@fit.hcmus.edu.vn',
                            location: 'TP.HCM, Vietnam',
                            name: participants[index],
                            status: 'Last online 22 hours ago',
                          ),
                        ),
                      )
                    }
                  else
                    {
                      Navigator.push<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) =>
                              UserDetailStudentScreen(
                            avatar:
                                'https://meta.vn/Data/image/2021/08/17/con-vit-vang-tren-fb-la-gi-trend-anh-avatar-con-vit-vang-la-gi-3.jpg',
                            role: 'Student',
                            course: 'Đồ án tốt nghiệp',
                            email: '18127044@student.hcmus.edu.vn',
                            location: 'TP.HCM, Vietnam',
                            name: participants[index],
                            status: 'Online just now',
                          ),
                        ),
                      )
                    }
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  // endregion

  Future<ModuleCourse> queryModule(Event e) async {
    try {
      return await ModuleService().getModule(
        _userStore.user.token,
        e.instance ?? 0,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future queryData() async {
    try {
      _content = await CourseContentService().getCourseContent(
        _userStore.user.token,
        _courseId,
      );
      _course = await CourseDetailService().getCourseById(
        _userStore.user.token,
        _courseId,
      );
      _upcoming = await CalendarService().getUpcomingByCourse(
        _userStore.user.token,
        _courseId,
      );
      _initBody();
    } catch (e) {
      if (e.toString() == "errorcoursecontextnotvalid") {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
          return EnrolScreen(
            courseId: widget.courseId,
          );
        }));
      }
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: queryData(),
          builder: (context, data) {
            final hasError = data.hasError;
            final hasData = _content.isNotEmpty && _course != null;
            return NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 200,
                    floating: true,
                    snap: true,
                    leading: TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        padding: EdgeInsets.zero,
                        shape: const CircleBorder(),
                      ),
                      child: const Icon(CupertinoIcons.back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        color: Theme.of(context).colorScheme.primary,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 64),
                          child: SizedBox(
                            height: 120,
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: AnimatedOpacity(
                                opacity: hasData ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 1200),
                                child: AutoSizeText(
                                  _course?.displayname ?? '',
                                  maxLines: 2,
                                  presetFontSizes: const [28, 24, 20],
                                  style: MoodleStyles.appBarTitleStyle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    bottom: hasData
                        ? TabBar(
                            indicatorPadding: const EdgeInsets.all(4),
                            indicator: const BoxDecoration(
                              color: MoodleColors.blueDark,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            isScrollable: true,
                            controller: _tabController,
                            tabs: _tabs,
                            onTap: (value) => setState(() => _index = value),
                          )
                        : null,
                  ),
                ];
              },
              body: hasError
                  ? ErrorCard(text: '${data.error}')
                  : !hasData
                      ? const LoadingCard()
                      : AnimatedOpacity(
                          opacity: hasData ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 1200),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(height: 12),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: _body[_index],
                                ),
                                Container(height: 12),
                              ],
                            ),
                          ),
                        ),
            );
          }),
    );
  }
}