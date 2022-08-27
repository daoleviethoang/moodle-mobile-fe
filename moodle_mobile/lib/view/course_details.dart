import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:moodle_mobile/constants/styles.dart';
import 'package:moodle_mobile/data/network/apis/calendar/calendar_service.dart';
import 'package:moodle_mobile/data/network/apis/contact/contact_service.dart';
import 'package:moodle_mobile/data/network/apis/course/course_content_service.dart';
import 'package:moodle_mobile/data/network/apis/course/course_detail_service.dart';
import 'package:moodle_mobile/data/network/apis/course/course_service.dart';
import 'package:moodle_mobile/data/network/apis/custom_api/custom_api.dart';
import 'package:moodle_mobile/data/network/apis/file/file_api.dart';
import 'package:moodle_mobile/data/network/apis/lti/lti_service.dart';
import 'package:moodle_mobile/data/network/apis/module/module_service.dart';
import 'package:moodle_mobile/data/network/apis/notes/notes_service.dart';
import 'package:moodle_mobile/data/network/apis/site_info/site_info_api.dart';
import 'package:moodle_mobile/data/network/constants/wsfunction_constants.dart';
import 'package:moodle_mobile/models/calendar/event.dart';
import 'package:moodle_mobile/models/contact/contact.dart';
import 'package:moodle_mobile/models/course/course_content.dart';
import 'package:moodle_mobile/models/course/course_detail.dart';
import 'package:moodle_mobile/models/lti/lti.dart';
import 'package:moodle_mobile/models/module/module.dart';
import 'package:moodle_mobile/models/module/module_content.dart';
import 'package:moodle_mobile/models/module/module_course.dart';
import 'package:moodle_mobile/models/note/note.dart';
import 'package:moodle_mobile/models/note/notes.dart';
import 'package:moodle_mobile/models/site_info/site_info.dart';
import 'package:moodle_mobile/view/activity/activity_screen.dart';
import 'package:moodle_mobile/view/assignment/file_assignment_tile.dart';
import 'package:moodle_mobile/view/common/content_item.dart';
import 'package:moodle_mobile/view/common/course/expandable_fab.dart';
import 'package:moodle_mobile/view/common/custom_text_field.dart';
import 'package:moodle_mobile/view/common/data_card.dart';
import 'package:moodle_mobile/view/common/tab_item.dart';
import 'package:moodle_mobile/view/enrol/enrol.dart';
import 'package:moodle_mobile/view/forum/add_post/add_assignment_screen.dart';
import 'package:moodle_mobile/view/forum/add_post/add_label_screen.dart';
import 'package:moodle_mobile/view/forum/add_post/add_poll_screen.dart';
import 'package:moodle_mobile/view/forum/forum_announcement_scren.dart';
import 'package:moodle_mobile/view/forum/forum_discussion_screen.dart';
import 'package:moodle_mobile/view/forum/forum_screen.dart';
import 'package:moodle_mobile/view/forum/poll_widget.dart';
import 'package:moodle_mobile/view/grade_in_one_course.dart';
import 'package:moodle_mobile/view/note/note_edit_dialog.dart';
import 'package:moodle_mobile/view/participants_in_one_course.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:numberpicker/numberpicker.dart';

import '../models/assignment/file_assignment.dart';

class CourseDetailsScreen extends StatefulWidget {
  final int courseId;

  const CourseDetailsScreen({Key? key, required this.courseId})
      : super(key: key);

  @override
  _CourseDetailsScreenState createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen>
    with TickerProviderStateMixin {
  Widget _fab = Container();

  // region Body data

  final _body = <Widget>[];
  Widget _homeTab = Container();
  Widget _notesTab = Container();
  Widget _activityTab = Container();
  Widget _announcementsTab = Container();
  Widget _discussionsTab = Container();
  Widget _eventsTab = Container();
  Widget _gradesTab = Container();
  Widget _peopleTab = Container();
  List<FileUpload> files = [];
  bool sortASC = true;

  /// Wrap each child in body in a scroll view and padding
  List<Widget> get _bodyWrapper {
    if (_body.isEmpty) return [Container()];

    return _body.map((w) {
      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        child: w,
      );
    }).toList();
  }

  Exception? _errored;
  Timer? _refreshErrorTimer;

  // endregion

  // region TabBar data
  TabController? _tabController;
  final _tabs = <Widget>[];

  int get _index => _tabController?.index ?? 0;

  // endregion

  // text controller
  TextEditingController urlController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  // choose number in add url
  int _sectionChoose = 0;

  // region Index getters

  int get _homeIndex => 0;

  int get _notesIndex => _body.indexOf(_notesTab);

  int get _activityIndex => _body.indexOf(_activityTab);

  int get _announcementsIndex => _body.indexOf(_announcementsTab);

  int get _discussionsIndex => _body.indexOf(_discussionsTab);

  int get _eventsIndex => _body.indexOf(_eventsTab);

  int get _gradesIndex => _body.indexOf(_gradesTab);

  int get _peopleIndex => _body.indexOf(_peopleTab);

  // endregion

  late int _courseId;
  late UserStore _userStore;
  CourseDetail? _course;
  List<CourseContent> _content = [];
  List<Event> _events = [];
  final Notes _notes = Notes();
  SiteInfo? _siteInfo;

  String get token => _userStore.user.token;

  bool isTeacher = false;

  // region Section check getters

  final activitySectionName = 'activity';
  final announcementModuleName = 'announcement';
  final discussionModuleName = 'discussion';

  bool get hasActivitySection {
    return _siteInfo?.functions?.any(
          (element) => element.name == Wsfunction.LOCAL_ADD_SECTION_COURSE,
        ) ??
        false;
  }

  bool get hasAddModuleAPI {
    return _siteInfo?.functions?.any(
          (element) => element.name == Wsfunction.LOCAL_ADD_MODULES,
        ) ??
        false;
  }

  bool get hasAddSectionAPI {
    return _siteInfo?.functions?.any(
          (element) => element.name == Wsfunction.LOCAL_ADD_SECTION_COURSE,
        ) ??
        false;
  }

  bool get hasNoteSection {
    return _siteInfo?.functions?.any(
          (element) => element.name == Wsfunction.UPDATE_NOTE,
        ) ??
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

  // endregion

  @override
  void initState() {
    super.initState();
    _courseId = widget.courseId;
    _userStore = GetIt.instance<UserStore>();
    checkIsTeacher();
  }

  @override
  void dispose() {
    _tabController?.removeListener(_updateIndex);
    _tabController?.dispose();
    super.dispose();
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
        _tabs.add(CourseDetailsTab(
          currentIndex: _index,
          index: _homeIndex,
          // icon: const Icon(CupertinoIcons.house),
          // activeIcon: const Icon(CupertinoIcons.house_fill),
          text: Text(str.home),
        ));
      }
    }
    try {
      _initNotesTab();
    } catch (e) {
      _notesTab = kReleaseMode ? Container() : ErrorCard(text: '$e');
    } finally {
      if (_notesTab is! Container) {
        _body.add(_notesTab);
        _tabs.add(CourseDetailsTab(
          currentIndex: _index,
          index: _notesIndex,
          // icon: const Icon(CupertinoIcons.doc),
          // activeIcon: const Icon(CupertinoIcons.doc_fill),
          text: Text(str.notes),
        ));
      }
    }
    try {
      _initActivityTab();
    } catch (e) {
      _activityTab = kReleaseMode ? Container() : ErrorCard(text: '$e');
    } finally {
      if (_activityTab is! Container) {
        _body.add(_activityTab);
        _tabs.add(CourseDetailsTab(
          currentIndex: _index,
          index: _activityIndex,
          // icon: const Icon(CupertinoIcons.photo_on_rectangle),
          // activeIcon: const Icon(CupertinoIcons.photo_fill_on_rectangle_fill),
          text: Text(str.activity),
        ));
      }
    }
    try {
      _initAnnouncementsTab();
    } catch (e) {
      _announcementsTab = kReleaseMode ? Container() : ErrorCard(text: '$e');
    } finally {
      if (_announcementsTab is! Container) {
        _body.add(_announcementsTab);
        _tabs.add(CourseDetailsTab(
          currentIndex: _index,
          index: _announcementsIndex,
          // icon: const Icon(CupertinoIcons.bell),
          // activeIcon: const Icon(CupertinoIcons.bell_fill),
          text: Text(str.announcement),
        ));
      }
    }
    try {
      _initDiscussionsTab();
    } catch (e) {
      _discussionsTab = kReleaseMode ? Container() : ErrorCard(text: '$e');
    } finally {
      if (_discussionsTab is! Container) {
        _body.add(_discussionsTab);
        _tabs.add(CourseDetailsTab(
          currentIndex: _index,
          index: _discussionsIndex,
          // icon: const Icon(CupertinoIcons.bubble_left_bubble_right),
          // activeIcon: const Icon(CupertinoIcons
          // .bubble_left_bubble_right_fill),
          text: Text(str.discussion),
        ));
      }
    }
    try {
      _initEventsTab();
    } catch (e) {
      _eventsTab = kReleaseMode ? Container() : ErrorCard(text: '$e');
    } finally {
      if (_eventsTab is! Container) {
        _body.add(_eventsTab);
        _tabs.add(CourseDetailsTab(
          currentIndex: _index,
          index: _eventsIndex,
          // icon: const Icon(Icons.calendar_month_outlined),
          // activeIcon: const Icon(Icons.calendar_month),
          text: Text(str.events),
        ));
      }
    }
    try {
      _initGradesTab();
    } catch (e) {
      _gradesTab = kReleaseMode ? Container() : ErrorCard(text: '$e');
    } finally {
      if (_gradesTab is! Container) {
        _body.add(_gradesTab);
        _tabs.add(CourseDetailsTab(
          currentIndex: _index,
          index: _gradesIndex,
          // icon: const Icon(CupertinoIcons.checkmark_circle),
          // activeIcon: const Icon(CupertinoIcons.checkmark_circle_fill),
          text: Text(str.grades),
        ));
      }
    }
    try {
      _initPeopleTab();
    } catch (e) {
      _peopleTab = kReleaseMode ? Container() : ErrorCard(text: '$e');
    } finally {
      if (_peopleTab is! Container) {
        _body.add(_peopleTab);
        _tabs.add(CourseDetailsTab(
          currentIndex: _index,
          index: _peopleIndex,
          // icon: const Icon(CupertinoIcons.person_3),
          // activeIcon: const Icon(CupertinoIcons.person_3_fill),
          text: Text(str.participants),
        ));
      }
    }

    _tabController = TabController(
      length: _tabs.length,
      initialIndex: _index,
      vsync: this,
    )..addListener(_updateIndex);
  }

  void _updateIndex() => setState(() {});

  // region Tabs

  void _initHomeTab() {
    _homeTab = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PollContainer(
          courseId: '$_courseId',
          userId: '${_userStore.user.id}',
          isTeacher: isTeacher,
          // TODO: poll: _poll,
        ),
        ..._content.map((c) {
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
                      completed: m.isCompleted,
                      onCompletionChange: (val) async {
                        try {
                          return await ModuleService()
                              .markModule(token, m.id!, val);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text(AppLocalizations.of(context)!.error),
                              backgroundColor: Colors.red));
                          return val;
                        }
                      },
                      title: title,
                      submissionId: m.instance ?? 0,
                      courseId: widget.courseId,
                      dueDate: dueDate,
                      isTeacher: isTeacher,
                    );
                  case ModuleName.chat:
                    return ChatItem(
                      completed: m.isCompleted,
                      onCompletionChange: (val) async {
                        try {
                          return await ModuleService()
                              .markModule(token, m.id!, val);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text(AppLocalizations.of(context)!.error),
                              backgroundColor: Colors.red));
                          return val;
                        }
                      },
                      title: title,
                      onPressed: () {},
                    );
                  case ModuleName.folder:
                    return Container();
                  case ModuleName.forum:
                    return Builder(builder: (context) {
                      // Check if this is Announcements/Discussion Forum
                      var newIndex = -1;
                      var newTitle = title;
                      if (_content.first == c) {
                        final name = title.toLowerCase();
                        if (name.contains(announcementModuleName)) {
                          newIndex = _announcementsIndex;
                          newTitle = AppLocalizations.of(context)!.announcement;
                        } else if (name.contains(discussionModuleName)) {
                          newIndex = _discussionsIndex;
                          newTitle = AppLocalizations.of(context)!.discussion;
                        }
                      }

                      return ForumItem(
                        completed: m.isCompleted,
                        onCompletionChange: (val) async {
                          try {
                            return await ModuleService()
                                .markModule(token, m.id!, val);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text(AppLocalizations.of(context)!.error),
                                backgroundColor: Colors.red));
                            return val;
                          }
                        },
                        title: newTitle,
                        onPressed: () {
                          // Switch to Announcements/Discussion Forum
                          if (newIndex != -1) {
                            _tabController?.animateTo(newIndex);
                            return;
                          }
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (BuildContext context) {
                                return ForumScreen(
                                  courseId: _courseId,
                                  forumId: m.instance,
                                  forumName: m.name,
                                );
                              },
                            ),
                          );
                        },
                      );
                    });
                  case ModuleName.label:
                    return LabelItem(
                        completed: m.isCompleted,
                        onCompletionChange: (val) async {
                          try {
                            return await ModuleService()
                                .markModule(token, m.id!, val);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text(AppLocalizations.of(context)!.error),
                                backgroundColor: Colors.red));
                            return val;
                          }
                        },
                        text: m.description ?? '');
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
                          completed: m.isCompleted,
                          onCompletionChange: (val) async {
                            ModuleService().markModule(token, m.id!, val);
                          },
                          title: title,
                          url: d.endpoint ?? '',
                          id: m.instance!,
                        );
                      },
                    );
                  case ModuleName.page:
                    return PageItem(
                      completed: m.isCompleted,
                      onCompletionChange: (val) async {
                        try {
                          return await ModuleService()
                              .markModule(token, m.id!, val);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text(AppLocalizations.of(context)!.error),
                              backgroundColor: Colors.red));
                          return val;
                        }
                      },
                      title: title,
                      onPressed: () {},
                    );
                  case ModuleName.quiz:
                    return QuizItem(
                      completed: m.isCompleted,
                      onCompletionChange: (val) async {
                        try {
                          return await ModuleService()
                              .markModule(token, m.id!, val);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text(AppLocalizations.of(context)!.error),
                              backgroundColor: Colors.red));
                          return val;
                        }
                      },
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
                      completed: m.isCompleted,
                      onCompletionChange: (val) async {
                        try {
                          return await ModuleService()
                              .markModule(token, m.id!, val);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text(AppLocalizations.of(context)!.error),
                              backgroundColor: Colors.red));
                          return val;
                        }
                      },
                      title: title,
                      documentUrl: url,
                    );
                  case ModuleName.url:
                    return UrlItem(
                      completed: m.isCompleted,
                      onCompletionChange: (val) async {
                        try {
                          return await ModuleService()
                              .markModule(token, m.id!, val);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text(AppLocalizations.of(context)!.error),
                              backgroundColor: Colors.red));
                          return val;
                        }
                      },
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
      ],
    );
  }

  void _initNotesTab() {
    if (!hasNoteSection) {
      _notesTab = Container();
      return;
    }
    _notesTab = SingleChildScrollView(
      child: Column(
        children: [
          Container(height: 6),
          NoteAddTextField(onTap: () async {
            await _openNoteDialog(context);
            await queryNotes();
            setState(() {});
          }),
          Container(height: 6),
          AnimatedOpacity(
            opacity: (_notes.isEmpty) ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: Padding(
              padding: EdgeInsets.only(top: _notes.isEmpty ? 16 : 0),
              child: Opacity(
                opacity: .5,
                child:
                    Center(child: Text(AppLocalizations.of(context)!.no_notes)),
              ),
            ),
          ),
          ..._notes.all.map((n) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: NoteCard(
                n,
                token,
                onCheckbox: (value) => NotesService().toggleDone(token, n),
                onPressed: () => _openNoteDialog(context, n),
                onDelete: () => NotesService().deleteNote(token, n),
              ),
            );
          })
        ],
      ),
    );
  }

  Future _openNoteDialog(BuildContext context, [Note? n]) async =>
      await showModalBottomSheet(
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
      );

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
      if (index == null) return Container();
      return ActivityScreen(
        sectionIndex: index,
        isTeacher: isTeacher,
        content: index != -1 ? _content[index] : null,
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
    if (_events.isEmpty) {
      _eventsTab = Container();
      return;
    }
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

  // region FAB

  dialogAddSection() async {
    var check = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.add_section_title,
                textScaleFactor: 0.8,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextFieldWidget(
                controller: nameController,
                hintText: AppLocalizations.of(context)!.new_section_name,
                haveLabel: false,
                borderRadius: Dimens.default_border_radius,
              ),
            ],
          ),
          actions: [
            Row(children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.cancel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      )),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(MoodleColors.grey),
                      shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))))),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    Navigator.pop(context, true);
                  },
                  child: Text(AppLocalizations.of(context)!.ok,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      )),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(MoodleColors.blue),
                      shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))))),
                ),
              ),
            ]),
          ],
        );
      },
    );
    if (check == true) {
      try {
        await CustomApi().addSectionCourse(
            _userStore.user.token, widget.courseId, nameController.text);
        setState(() {
          _content.add(CourseContent(_content.length, nameController.text, 1,
              "", 0, _content.length, 0, true, []));
          nameController.clear();
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
      }
    }
  }

  // dialogAddLabel() async {
  //   var check = await showDialog<bool>(context: context,builder: (BuildContext (context) {
  //     return AlertDialog()
  //   }));
  // }

  dialogAddUrl() async {
    if (_content.length - 1 < 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.course_not_have_section),
          backgroundColor: Colors.red));
      return;
    }
    int max = _content.length - 1;
    var check = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0))),
          contentPadding: EdgeInsets.only(top: 0.0),
          content: StatefulBuilder(builder: (context, sBSetState) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.0),
                          topRight: Radius.circular(12.0)),
                      color: MoodleColors.blue,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.add_url_title,
                      //textScaleFactor: 0.8,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Text(
                      AppLocalizations.of(context)!.number_section + ":",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: NumberPicker(
                      axis: Axis.horizontal,
                      value: _sectionChoose,
                      minValue: 0,
                      maxValue: max,
                      haptics: true,
                      zeroPad: true,
                      selectedTextStyle: TextStyle(
                        color: MoodleColors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(width: 1.5, color: MoodleColors.blue),
                      ),
                      onChanged: (value) =>
                          sBSetState(() => _sectionChoose = value),
                    ),
                  ),
                  Text(
                    _content[_sectionChoose].name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(8, 10, 8, 8),
                    child: CustomTextFieldWidget(
                      controller: nameController,
                      hintText: AppLocalizations.of(context)!.name_module,
                      haveLabel: true,
                      borderRadius: Dimens.default_border_radius,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: CustomTextFieldWidget(
                      controller: urlController,
                      hintText: AppLocalizations.of(context)!.url_link,
                      haveLabel: true,
                      borderRadius: Dimens.default_border_radius,
                    ),
                  )
                ]);
          }),
          actions: [
            Row(children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.cancel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      )),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(MoodleColors.grey),
                      shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))))),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    Navigator.pop(context, true);
                  },
                  child: Text(AppLocalizations.of(context)!.ok,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      )),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(MoodleColors.blue),
                      shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))))),
                ),
              ),
            ]),
          ],
        );
      },
    );
    if (check == true) {
      try {
        await CustomApi().addModuleUrl(_userStore.user.token, widget.courseId,
            nameController.text, _sectionChoose, urlController.text);
        setState(() {
          _content[_sectionChoose].modules.add(Module(
              id: 100,
              name: nameController.text,
              modname: ModuleName.url,
              contents: [ModuleContent(fileurl: urlController.text)]));
          nameController.clear();
          urlController.clear();
          _sectionChoose = 0;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text(AppLocalizations.of(context)!.add_url_success_message),
            backgroundColor: Colors.green));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
      }
    }
  }

  dialogAddFile() async {
    if (_content.length - 1 < 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.course_not_have_section),
          backgroundColor: Colors.red));
      return;
    }
    int max = _content.length - 1;
    var check = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0))),
          contentPadding: EdgeInsets.all(0),
          content:
              StatefulBuilder(builder: (context, StateSetter setInnerState) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.0),
                          topRight: Radius.circular(12.0)),
                      color: MoodleColors.blue,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.add_file_title,
                      //textScaleFactor: 0.8,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Text(
                      AppLocalizations.of(context)!.number_section + ":",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Center(
                        child: NumberPicker(
                          axis: Axis.horizontal,
                          value: _sectionChoose,
                          minValue: 0,
                          maxValue: max,
                          haptics: true,
                          zeroPad: true,
                          selectedTextStyle: TextStyle(
                            color: MoodleColors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                width: 1.5, color: MoodleColors.blue),
                          ),
                          onChanged: (value) =>
                              setInnerState(() => _sectionChoose = value),
                        ),
                      )),
                  Text(
                    _content[_sectionChoose].name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(8, 10, 8, 8),
                    child: CustomTextFieldWidget(
                      controller: nameController,
                      hintText: AppLocalizations.of(context)!.name_module,
                      haveLabel: true,
                      borderRadius: Dimens.default_border_radius,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(8, 10, 8, 0),
                    child: files.isNotEmpty
                        ? FileAssignmentTile(
                            file: files.first,
                            rename: rename,
                            canEdit: true,
                            delete: (i) {
                              setInnerState(() => files.removeAt(0));
                            },
                            index: 0,
                          )
                        : const Center(
                            child: Icon(
                              Icons.space_bar_rounded,
                              size: 30,
                            ),
                          ),
                  ),
                  files.isEmpty ? buildSelectFile(setInnerState) : Container(),
                ]);
          }),
          actions: [
            Row(children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    if (files.isNotEmpty) {
                      files.removeAt(0);
                    }
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.cancel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      )),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(MoodleColors.grey),
                      shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))))),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    if (files.isNotEmpty) {
                      Navigator.pop(context, true);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(AppLocalizations.of(context)!
                              .message_missing_file_add),
                          backgroundColor: Colors.red));
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.ok,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      )),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(MoodleColors.blue),
                    shape: MaterialStateProperty.all(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ],
        );
      },
    );
    if (check == true) {
      try {
        int fileId = await FileApi().uploadFile(
            token, files.first.filepath, files.first.filename, null);

        await CustomApi().addFile(_userStore.user.token, widget.courseId,
            nameController.text, _sectionChoose, fileId);

        await reGetCourseContent();

        setState(() {
          nameController.clear();
          urlController.clear();
          _sectionChoose = 0;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
      }

      files.removeAt(0);
    }
  }

  void _buildFab(BuildContext context) {
    final icons = [
      Icons.add,
      Icons.link,
      Icons.poll,
      Icons.file_upload_outlined,
      Icons.text_format_outlined,
      Icons.task,
    ];
    _fab = FabWithIcons(
      icons: icons,
      onIconTapped: (index) async {
        if (index == 0) {
          if (hasAddSectionAPI) {
            await dialogAddSection();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(AppLocalizations.of(context)!.api_unsupported),
                backgroundColor: Colors.red));
          }
        }
        if (index == 1) {
          if (hasAddModuleAPI) {
            await dialogAddUrl();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(AppLocalizations.of(context)!.api_unsupported),
                backgroundColor: Colors.red));
          }
        }
        if (index == 2) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (builder) =>
                      AddPollScreen(courseId: widget.courseId)));
        }
        if (index == 3) {
          if (hasAddModuleAPI) {
            await dialogAddFile();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(AppLocalizations.of(context)!.api_unsupported),
                backgroundColor: Colors.red));
          }
        }
        if (index == 4) {
          if (hasAddModuleAPI) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (builder) => AddLabelScreen(
                  courseId: widget.courseId,
                  sectionList: _content,
                ),
              ),
            ).then((_) async {
              await reGetCourseContent();
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(AppLocalizations.of(context)!.api_unsupported),
                backgroundColor: Colors.red));
          }
        }
        if (index == 5) {
          if (hasAddModuleAPI) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (builder) => AddAssignmentScreen(
                  courseId: widget.courseId,
                  sectionList: _content,
                ),
              ),
            ).then((_) async {
              await reGetCourseContent();
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(AppLocalizations.of(context)!.api_unsupported),
                backgroundColor: Colors.red));
          }
        }
      },
    );
  }

  // endregion

  // region Data queries

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

  Future queryNotes() async {
    _notes.replace(
        fromNotes: await NotesService().getCourseNotes(
      token,
      _courseId,
      _course?.displayname,
    ));
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
      await queryNotes();
      _siteInfo = await SiteInfoApi().getSiteInfo(token);
      await CourseService().triggerViewCourse(
        token,
        _courseId,
      );
      _initBody();
    } catch (e) {
      if (e.toString() == "errorcoursecontextnotvalid") {
        _showEnrolScreen();
      } else {
        rethrow;
      }
    }
  }

  Future reGetCourseContent() async {
    try {
      var contentResponse = await CourseContentService().getCourseContent(
        token,
        _courseId,
      );
      setState(() {
        _content = contentResponse;
      });
    } catch (e) {}
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
        _showEnrolScreen();
      }
      rethrow;
    }
  }

  void _showEnrolScreen() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
      return EnrolScreen(courseId: widget.courseId);
    }));
  }

  // endregion

  @override
  Widget build(BuildContext context) {
    _buildFab(context);
    return Scaffold(
      floatingActionButton: AnimatedOpacity(
        opacity:
            (_index == _homeIndex && isTeacher && _errored == null) ? 1 : 0,
        duration: const Duration(milliseconds: 300),
        child: IgnorePointer(
          ignoring: !(_index == _homeIndex && isTeacher && _errored == null),
          child: _fab,
        ),
      ),
      body: FutureBuilder(
          future: queryData(),
          builder: (context, data) {
            final hasError = data.hasError;
            final hasData = _content.isNotEmpty && _course != null;
            if (hasError) {
              if (kDebugMode) {
                print('${data.error}');
              }
              _errored = data.error as Exception;
              _refreshErrorTimer ??=
                  Timer.periodic(const Duration(seconds: 5), (timer) async {
                if (!mounted) {
                  timer.cancel();
                  _refreshErrorTimer = null;
                  return;
                }
                if (_errored != null) {
                  setState(() {});
                } else {
                  timer.cancel();
                  _refreshErrorTimer = null;
                }
              });
            } else if (_errored != null) {
              _errored = null;
            }
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
                      onPressed: () {
                        if (_index != _homeIndex) {
                          _tabController?.animateTo(_homeIndex);
                        } else {
                          Navigator.pop(context);
                        }
                      },
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
                            tabs: _tabs,
                            controller: _tabController,
                            isScrollable: true,
                            indicatorPadding: const EdgeInsets.all(4),
                            indicator: const BoxDecoration(
                              color: MoodleColors.blueDark,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            // unselectedLabelStyle: const TextStyle(fontSize: 0),
                            onTap: (value) => _tabController?.animateTo(value),
                          )
                        : null,
                  ),
                ];
              },
              body: Stack(
                alignment: Alignment.topCenter,
                children: [
                  AnimatedOpacity(
                    opacity: hasData ? 1 : 0,
                    duration: const Duration(milliseconds: 1200),
                    child: IgnorePointer(
                      ignoring: !hasData,
                      child: _tabController == null
                          ? Container()
                          : TabBarView(
                              controller: _tabController,
                              children: _bodyWrapper),
                    ),
                  ),
                  AnimatedOpacity(
                      opacity: (hasError) ? 1 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: IgnorePointer(
                        ignoring: !hasError,
                        child: ErrorCard(
                            text: AppLocalizations.of(context)!.error_connect),
                      )),
                  AnimatedOpacity(
                      opacity: (!hasData) ? 1 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: IgnorePointer(
                          ignoring: hasData, child: const LoadingCard())),
                ],
              ),
            );
          }),
    );
  }

  Widget buildSelectFile(StateSetter setInnerState) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
        color: MoodleColors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 30, bottom: 5, top: 5, right: 30),
        child: TextButton.icon(
          onPressed: () async {
            await getFileFromStorage(setInnerState);
            //Navigator.pop(context);
          },
          icon: const Icon(
            Icons.library_add,
            color: MoodleColors.black,
            size: 30,
          ),
          label: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              AppLocalizations.of(context)!.get_file_from_storage,
              style: const TextStyle(color: MoodleColors.black, fontSize: 16),
            ),
          ),
          style: TextButton.styleFrom(
            alignment: Alignment.centerLeft,
            primary: MoodleColors.white,
          ),
        ),
      ),
    );
  }

  getFileFromStorage(setInnerState) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        PlatformFile file = result.files.first;
        // check size more than condition
        if (file.size + caculateByteSize() > 5242880) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context)!.file_size_bigger),
              backgroundColor: Colors.red));
          return;
        }
        // check number file more than condition
        if (files.length == 1) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context)!.number_file_full),
              backgroundColor: Colors.red));
          return;
        }
        // check file same name
        bool check = checkOverwrite(file);
        if (check == true) return;
        // add file
        setInnerState(
          () => files.add(
            FileUpload(
                filename: file.name,
                filepath: file.path ?? "",
                timeModified: DateTime.now(),
                filesize: file.size),
          ),
        );

        // setState(() {
        //   files.sort(((a, b) => a.filename.compareTo(b.filename)));
        //   if (sortASC == false) {
        //     files.reversed;
        //   }
        // });
      }
    } catch (error) {
      print(error.toString());
    }
  }

  int caculateByteSize() {
    int sum = 0;
    for (var item in files) {
      sum += item.filesize;
    }
    return sum;
  }

  bool checkOverwrite(PlatformFile file) {
    int index = -1;
    for (var i = 0; i < files.length; i++) {
      if (files[i].filename == file.name) {
        index = i;
        break;
      }
    }
    if (index != -1) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.override_file),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    files[index] = FileUpload(
                        filename: file.name,
                        filepath: file.path ?? "",
                        timeModified: DateTime.now(),
                        filesize: file.size);
                  });

                  // break dialog
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)!.ok),
              ),
            ],
          );
        },
      );
      return true;
    }
    return false;
  }

  void rename(int index, String newName) {
    setState(() {
      files[0].filename = newName;
    });
  }
}
