import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/styles.dart';
import 'package:moodle_mobile/data/network/apis/calendar/calendar_service.dart';
import 'package:moodle_mobile/data/network/apis/course/course_content_service.dart';
import 'package:moodle_mobile/data/network/apis/course/course_detail_service.dart';
import 'package:moodle_mobile/data/network/apis/course/course_service.dart';
import 'package:moodle_mobile/data/network/apis/lti/lti_service.dart';
import 'package:moodle_mobile/data/network/apis/module/module_service.dart';
import 'package:moodle_mobile/models/calendar/event.dart';
import 'package:moodle_mobile/models/course/course_content.dart';
import 'package:moodle_mobile/models/course/course_detail.dart';
import 'package:moodle_mobile/models/lti/lti.dart';
import 'package:moodle_mobile/models/module/module.dart';
import 'package:moodle_mobile/models/module/module_course.dart';
import 'package:moodle_mobile/view/common/content_item.dart';
import 'package:moodle_mobile/view/common/data_card.dart';
import 'package:moodle_mobile/view/enrol/enrol.dart';
import 'package:moodle_mobile/view/forum/forum_announcement_scren.dart';
import 'package:moodle_mobile/view/forum/forum_screen.dart';
import 'package:moodle_mobile/view/grade_in_one_course.dart';
import 'package:moodle_mobile/view/participants_in_one_course.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CourseDetailsScreen extends StatefulWidget {
  final int courseId;

  const CourseDetailsScreen({Key? key, required this.courseId})
      : super(key: key);

  @override
  _CourseDetailsScreenState createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  final _tabs = <Widget>[];
  var _index = 0;
  final _body = <Widget>[];
  Widget _homeTab = Container();
  Widget _announcementsTab = Container();
  Widget _discussionsTab = Container();
  Widget _eventsTab = Container();
  Widget _gradesTab = Container();
  Widget _peopleTab = Container();

  late int _courseId;
  late UserStore _userStore;
  CourseDetail? _course;
  List<CourseContent> _content = [];
  List<Event> _events = [];

  @override
  void initState() {
    super.initState();
    _courseId = widget.courseId;
    _userStore = GetIt.instance<UserStore>();
  }

  // region BODY

  void _initBody() {
    _body.clear();
    try {
      _initHomeTab();
    } catch (e) {
      _homeTab = ErrorCard(text: '$e');
    } finally {
      if (_homeTab is! Container) {
        _body.add(_homeTab);
      }
    }
    try {
      _initAnnouncementsTab();
    } catch (e) {
      _announcementsTab = ErrorCard(text: '$e');
    } finally {
      if (_announcementsTab is! Container) {
        _body.add(_announcementsTab);
      }
    }
    try {
      _initDiscussionsTab();
    } catch (e) {
      _discussionsTab = ErrorCard(text: '$e');
    } finally {
      if (_discussionsTab is! Container) {
        _body.add(_discussionsTab);
      }
    }
    try {
      _initEventsTab();
    } catch (e) {
      _eventsTab = ErrorCard(text: '$e');
    } finally {
      if (_eventsTab is! Container) {
        _body.add(_eventsTab);
      }
    }
    try {
      _initGradesTab();
    } catch (e) {
      _gradesTab = ErrorCard(text: '$e');
    } finally {
      if (_gradesTab is! Container) {
        _body.add(_gradesTab);
      }
    }
    try {
      _initPeopleTab();
    } catch (e) {
      _peopleTab = ErrorCard(text: '$e');
    } finally {
      if (_peopleTab is! Container) {
        _body.add(_peopleTab);
      }
    }
    _initTabList();
  }

  void _initTabList() {
    _tabs.clear();
    if (_homeTab is! Container) {
      _tabs.add(Tab(child: Text(AppLocalizations.of(context)!.home)));
    }
    if (_announcementsTab is! Container) {
      _tabs.add(Tab(child: Text(AppLocalizations.of(context)!.announcement)));
    }
    if (_discussionsTab is! Container) {
      _tabs.add(Tab(child: Text(AppLocalizations.of(context)!.discussion)));
    }
    if (_eventsTab is! Container) {
      _tabs.add(Tab(child: Text(AppLocalizations.of(context)!.events)));
    }
    if (_gradesTab is! Container) {
      _tabs.add(Tab(child: Text(AppLocalizations.of(context)!.grades)));
    }
    if (_peopleTab is! Container) {
      _tabs.add(Tab(child: Text(AppLocalizations.of(context)!.participants)));
    }

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
                case ModuleName.lti:
                  return FutureBuilder(
                    future: queryLti(m.instance ?? 0),
                    builder: (context, data) {
                      if (data.hasError) {
                        throw Exception(data.error);
                      }
                      if (!data.hasData) {
                        return const LoadingCard();
                      }
                      Lti d = data.data as Lti;
                      return UrlItem(
                        title: title,
                        url: d.endpoint ?? '',
                      );
                    },
                  );
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
                  throw Exception(AppLocalizations.of(context)!
                      .err_unknown_module(m.modname ?? ''));
              }
            } catch (e) {
              // FIXME: Assignment text is [] instead of string
              if (kDebugMode) {
                print('$m');
              }
              return ErrorCard(text: '$e');
            }
          }).toList(),
        );
      }).toList(),
    );
  }

  void _initAnnouncementsTab() {
    if (_content.isEmpty) {
      _announcementsTab = Container();
      return;
    }
    _announcementsTab = ForumAnnouncementScreen(
      forumId: _content[0].modules[0].instance ?? 0,
      courseId: _courseId,
    );
  }

  void _initDiscussionsTab() {
    if (_content.isEmpty) {
      _discussionsTab = Container();
      return;
    }
    _discussionsTab = ForumDiscussionScreen(
      forumId: _content[0].modules[1].instance ?? 0,
      courseId: _courseId,
    );
  }

  void _initEventsTab() {
    if (_events.isEmpty) {
      _eventsTab = Container();
      return;
    }
    _eventsTab = Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.upcoming_events,
              style: MoodleStyles.courseHeaderStyle),
          Container(height: 16),
          ..._events.map((e) {
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
                throw Exception(AppLocalizations.of(context)!
                    .err_unknown_module(e.modulename ?? ''));
            }
          }).toList(),
        ],
      ),
    );
  }

  void _initGradesTab() {
    _gradesTab =
        GradeInOneCourse(courseId: _courseId, courseName: _course!.displayname);
  }

  void _initPeopleTab() {
    _peopleTab = ParticipantsInOneCourse(
        courseId: _courseId, courseName: _course!.displayname);
  }

  // endregion

  Future<Lti> queryLti(int toolid) async {
    try {
      return await LtiService().getLti(
        _userStore.user.token,
        toolid,
      );
    } catch (e) {
      rethrow;
    }
  }

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
      _events = await CalendarService().getUpcomingByCourse(
        _userStore.user.token,
        _courseId,
      );
      await CourseService().triggerViewCourse(
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
                    bottom: hasData && _tabController != null
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