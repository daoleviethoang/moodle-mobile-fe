import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/styles.dart';
import 'package:moodle_mobile/data/network/apis/calendar/calendar_service.dart';
import 'package:moodle_mobile/data/network/apis/contact/contact_service.dart';
import 'package:moodle_mobile/data/network/apis/course/course_content_service.dart';
import 'package:moodle_mobile/data/network/apis/course/course_detail_service.dart';
import 'package:moodle_mobile/data/network/apis/course/course_service.dart';
import 'package:moodle_mobile/data/network/apis/lti/lti_service.dart';
import 'package:moodle_mobile/data/network/apis/module/module_service.dart';
import 'package:moodle_mobile/data/network/apis/notes/notes_service.dart';
import 'package:moodle_mobile/data/network/apis/site_info/site_info_api.dart';
import 'package:moodle_mobile/models/calendar/event.dart';
import 'package:moodle_mobile/models/contact/contact.dart';
import 'package:moodle_mobile/models/course/course_content.dart';
import 'package:moodle_mobile/models/course/course_detail.dart';
import 'package:moodle_mobile/models/lti/lti.dart';
import 'package:moodle_mobile/models/module/module.dart';
import 'package:moodle_mobile/models/module/module_course.dart';
import 'package:moodle_mobile/models/note/note.dart';
import 'package:moodle_mobile/models/note/notes.dart';
import 'package:moodle_mobile/models/site_info/site_info.dart';
import 'package:moodle_mobile/view/activity/activity_screen.dart';
import 'package:moodle_mobile/view/common/content_item.dart';
import 'package:moodle_mobile/view/common/custom_text_field.dart';
import 'package:moodle_mobile/view/common/data_card.dart';
import 'package:moodle_mobile/view/enrol/enrol.dart';
import 'package:moodle_mobile/view/forum/forum_announcement_scren.dart';
import 'package:moodle_mobile/view/forum/forum_screen.dart';
import 'package:moodle_mobile/view/grade_in_one_course.dart';
import 'package:moodle_mobile/view/note/note_edit_dialog.dart';
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
  Widget _notesTab = Container();
  Widget _activityTab = Container();
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
  final Notes _notes = Notes();
  SiteInfo? _siteInfo;

  String get token => _userStore.user.token;

  bool isTeacher = false;

  final activitySectionName = 'activity';
  final announcementModuleName = 'announcement';
  final discussionModuleName = 'discussion';

  bool get hasActivitySection {
    return _siteInfo?.functions?.any(
            (element) => element.name == "local_modulews_add_section_course") ??
        false;
  }

  bool get hasAnnouncementModule {
    return _content.first.modules.any((m) {
      return m.name?.toLowerCase().contains(announcementModuleName) ?? false;
    });
  }

  bool get hasDiscussionForumModule {
    return _content.first.modules.any((m) {
      return m.name?.toLowerCase().contains(discussionModuleName) ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    _courseId = widget.courseId;
    _userStore = GetIt.instance<UserStore>();
    checkIsTeacher();
  }

  checkIsTeacher() async {
    List<Contact> contacts =
        await ContactService().getContacts(token, widget.courseId);
    if (contacts.any((element) => element.id == _userStore.user.id)) {
      setState(() {
        isTeacher = true;
      });
    }
  }

  // region BODY

  void _initBody() {
    _body.clear();
    _tabs.clear();

    final str = AppLocalizations.of(context)!;
    try {
      _initHomeTab();
    } catch (e) {
      _homeTab = kReleaseMode ? Container() : ErrorCard(text: '$e');
    } finally {
      if (_homeTab is! Container) {
        _body.add(_homeTab);
        _tabs.add(Tab(child: Text(str.home)));
      }
    }
    try {
      _initNotesTab();
    } catch (e) {
      _notesTab = kReleaseMode ? Container() : ErrorCard(text: '$e');
    } finally {
      if (_notesTab is! Container) {
        _body.add(_notesTab);
        _tabs.add(Tab(child: Text(str.notes)));
      }
    }
    try {
      _initActivityTab();
    } catch (e) {
      _activityTab = kReleaseMode ? Container() : ErrorCard(text: '$e');
    } finally {
      if (_activityTab is! Container) {
        _body.add(_activityTab);
        _tabs.add(Tab(child: Text(str.activity)));
      }
    }
    try {
      _initAnnouncementsTab();
    } catch (e) {
      _announcementsTab = kReleaseMode ? Container() : ErrorCard(text: '$e');
    } finally {
      if (_announcementsTab is! Container) {
        _body.add(_announcementsTab);
        _tabs.add(Tab(child: Text(str.announcement)));
      }
    }
    try {
      _initDiscussionsTab();
    } catch (e) {
      _discussionsTab = kReleaseMode ? Container() : ErrorCard(text: '$e');
    } finally {
      if (_discussionsTab is! Container) {
        _body.add(_discussionsTab);
        _tabs.add(Tab(child: Text(str.discussion)));
      }
    }
    try {
      _initEventsTab();
    } catch (e) {
      _eventsTab = kReleaseMode ? Container() : ErrorCard(text: '$e');
    } finally {
      if (_eventsTab is! Container) {
        _body.add(_eventsTab);
        _tabs.add(Tab(child: Text(str.events)));
      }
    }
    try {
      _initGradesTab();
    } catch (e) {
      _gradesTab = kReleaseMode ? Container() : ErrorCard(text: '$e');
    } finally {
      if (_gradesTab is! Container) {
        _body.add(_gradesTab);
        _tabs.add(Tab(child: Text(str.grades)));
      }
    }
    try {
      _initPeopleTab();
    } catch (e) {
      _peopleTab = kReleaseMode ? Container() : ErrorCard(text: '$e');
    } finally {
      if (_peopleTab is! Container) {
        _body.add(_peopleTab);
        _tabs.add(Tab(child: Text(str.participants)));
      }
    }

    _tabController = TabController(
      length: _tabs.length,
      initialIndex: _index,
      vsync: this,
    );
  }

  // region Tabs

  void _initHomeTab() {
    _homeTab = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _content.map((c) {
        if (c.name.toLowerCase() == activitySectionName) {
          return Container();
        }
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
                    isTeacher: isTeacher,
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
                      // Switch to special module
                      if (_content.first == c) {
                        final name = m.name?.toLowerCase() ?? '';
                        var newIndex = -1;
                        if (name.contains(announcementModuleName)) {
                          newIndex = _body.indexOf(_announcementsTab);
                        } else if (name.contains(discussionModuleName)) {
                          newIndex = _body.indexOf(_discussionsTab);
                        }
                        if (newIndex != -1) {
                          setState(() {
                            _tabController?.animateTo(newIndex);
                          });
                          return;
                        }
                      }
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
                        id: m.instance!,
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
                    courseId: widget.courseId,
                    isTeacher: isTeacher,
                  );
                case ModuleName.resource:
                  var url = m.contents?[0].fileurl ?? '';
                  if (url.isNotEmpty) {
                    url = url.substring(0, url.indexOf('?forcedownload'));
                    url += '?token=' + token;
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

  void _initNotesTab() {
    _notesTab = SingleChildScrollView(
      child: AnimatedOpacity(
        opacity: (_notes.isEmpty) ? .5 : 1,
        duration: const Duration(milliseconds: 300),
        child: Column(
          children: [
            Container(height: 6),
            NoteAddTextField(
              onTap: () => _openNoteDialog(context),
            ),
            Container(height: 6),
            AnimatedOpacity(
              opacity: (_notes.isEmpty) ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: Opacity(
                opacity: .5,
                child:
                    Center(child: Text(AppLocalizations.of(context)!.no_notes)),
              ),
            ),
            ..._notes.importantFirst.map((n) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: NoteCard(
                  n,
                  token,
                  onCheckbox: (value) async =>
                      await NotesService().toggleDone(token, n),
                  onPressed: () => _openNoteDialog(context, n),
                ),
              );
            })
          ],
        ),
      ),
    );
  }

  void _openNoteDialog(BuildContext context, [Note? n]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => NoteEditDialog(
        token: token,
        uid: _userStore.user.id,
        cid: _courseId,
        note: n,
      ),
    ).then((result) {
      if (result.runtimeType is Note) queryData();
    });
  }

  void _initActivityTab() {
    if (!hasActivitySection) {
      _activityTab = Container();
      return;
    }
    var activityList = _content
        .where((element) => element.name.toLowerCase() == activitySectionName);
    _activityTab = Builder(builder: (context) {
      int? index =
          activityList.isNotEmpty ? _content.indexOf(activityList.first) : null;
      return ActivityScreen(
        sectionIndex: (index == null) ? 0 : index,
        isTeacher: isTeacher,
        content: (index == null) ? null : _content[index],
        courseId: widget.courseId,
        reGetContent: reGetContentForActivityTab,
      );
    });
  }

  void _initAnnouncementsTab() {
    if (!hasAnnouncementModule) {
      _announcementsTab = Container();
      return;
    }
    _announcementsTab = ForumAnnouncementScreen(
      forumId: _content.first.modules
          .firstWhere((m) =>
              m.name?.toLowerCase().contains(announcementModuleName) ?? false)
          .instance!,
      courseId: _courseId,
      isTeacher: isTeacher,
    );
  }

  void _initDiscussionsTab() {
    if (!hasDiscussionForumModule) {
      _discussionsTab = Container();
      return;
    }
    _discussionsTab = ForumDiscussionScreen(
      forumId: _content.first.modules
          .firstWhere((m) =>
              m.name?.toLowerCase().contains(discussionModuleName) ?? false)
          .instance!,
      courseId: _courseId,
    );
  }

  void _initEventsTab() {
    // if (_events.isEmpty) {
    //   _eventsTab = Container();
    //   return;
    // }
    _eventsTab = SizedBox(
      height: MediaQuery.of(context).size.height - 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.upcoming_events,
              style: MoodleStyles.courseHeaderStyle),
          Container(height: 16),
          if (_events.isEmpty)
            Center(
              child: Text(
                AppLocalizations.of(context)!.nothing_yet,
              ),
            ),
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
                        isTeacher: isTeacher,
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
                        isTeacher: isTeacher,
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

  // endregion

  Future<Lti> queryLti(int toolid) async {
    try {
      return await LtiService().getLti(
        token,
        toolid,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<ModuleCourse> queryModule(Event e) async {
    try {
      return await ModuleService().getModule(
        token,
        e.instance ?? 0,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future queryData() async {
    try {
      _content = await CourseContentService().getCourseContent(
        token,
        _courseId,
      );
      _course = await CourseDetailService().getCourseById(
        token,
        _courseId,
      );
      _events = await CalendarService().getUpcomingByCourse(
        token,
        _courseId,
      );
      _notes.replace(
          fromNotes: await NotesService().getCourseNotes(
        token,
        _courseId,
        _course?.displayname,
      ));
      _siteInfo = await SiteInfoApi().getSiteInfo(token);
      await CourseService().triggerViewCourse(
        token,
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
      } else {
        rethrow;
      }
    }
  }

  Future reGetContentForActivityTab(bool isSetState) async {
    try {
      if (isSetState) {
        var contentResponse = await CourseContentService().getCourseContent(
          token,
          _courseId,
        );
        setState(() {
          _content = contentResponse;
        });
        var activityList =
            _content.where((element) => element.name == "Activity");
        if (activityList.isNotEmpty) {
          int index = _content.indexOf(activityList.first);
          setState(() {
            _activityTab = ActivityScreen(
              sectionIndex: index,
              isTeacher: isTeacher,
              content: _content[index],
              courseId: widget.courseId,
              reGetContent: reGetContentForActivityTab,
            );
          });
        }
      } else {
        _content = await CourseContentService().getCourseContent(
          token,
          _courseId,
        );
      }
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
                  ? Center(
                      child: ErrorCard(
                          text: AppLocalizations.of(context)!.error_connect))
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