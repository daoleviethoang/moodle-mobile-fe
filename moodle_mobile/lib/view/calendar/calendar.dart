import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/styles.dart';
import 'package:moodle_mobile/data/network/apis/calendar/calendar_service.dart';
import 'package:moodle_mobile/data/network/apis/module/module_service.dart';
import 'package:moodle_mobile/data/network/apis/site_info/site_info_api.dart';
import 'package:moodle_mobile/data/network/constants/wsfunction_constants.dart';
import 'package:moodle_mobile/models/calendar/event.dart';
import 'package:moodle_mobile/models/module/module.dart';
import 'package:moodle_mobile/models/module/module_course.dart';
import 'package:moodle_mobile/models/site_info/site_info.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/common/content_item.dart';
import 'package:moodle_mobile/view/common/custom_button.dart';
import 'package:moodle_mobile/view/common/custom_button_short.dart';
import 'package:moodle_mobile/view/common/data_card.dart';
import 'package:moodle_mobile/view/note/note_list.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CalendarScreen extends StatefulWidget {
  final Observable<bool>? jumpOpenFlag;

  const CalendarScreen({
    Key? key,
    this.jumpOpenFlag,
  }) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with TickerProviderStateMixin {
  Widget _tabView = Container();
  Widget _body = Container();
  Widget _calendarTabView = Container();
  Widget _monthView = Container();
  Widget _dayView = Container();
  Widget _noteTabView = Container();

  late TabController _tabController;

  var _jumpDate = DateTime.now();
  var _selectedDay = DateTime.now();
  var _focusedDay = DateTime.now();
  var _selectedEvents = <Event>[];

  late UserStore _userStore;
  Map<String, List<Event>> _events = {};
  Observable<bool>? _jumpOpenFlag;
  final noteSearchShowFlag = Observable<bool>(false);
  SiteInfo? _siteInfo;

  Exception? _errored;
  Timer? _refreshErrorTimer;

  bool get hasNoteSection {
    return _siteInfo?.functions?.any(
          (element) => element.name == Wsfunction.UPDATE_NOTE,
        ) ??
        false;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      initialIndex: 0,
      vsync: this,
    );

    _userStore = GetIt.instance<UserStore>();
    _jumpOpenFlag = widget.jumpOpenFlag;
    _jumpOpenFlag?.observe((p0) {
      if (_jumpOpenFlag?.value ?? false) {
        _jumpOpenFlag?.toggle();
        if (_tabController.index == 0) {
          _jumpToDate();
        } else {
          noteSearchShowFlag.toggle();
        }
      }
    });
  }

  void _initTabView() {
    _tabView = TabBar(
      controller: _tabController,
      indicatorColor: Colors.transparent,
      padding: EdgeInsets.zero,
      indicatorPadding: EdgeInsets.zero,
      labelPadding: EdgeInsets.zero,
      isScrollable: true,
      tabs: [
        Tab(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: CustomButtonShort(
              text: AppLocalizations.of(context)!.calendar,
              textColor: (_tabController.index == 0)
                  ? MoodleColors.blue
                  : Colors.black,
              bgColor: (_tabController.index == 0)
                  ? MoodleColors.brightGray
                  : MoodleColors.white,
              blurRadius: 3,
              onPressed: () => _tabController.index = 0,
            ),
          ),
        ),
        Tab(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: CustomButtonShort(
              text: AppLocalizations.of(context)!.notes,
              textColor: (_tabController.index == 1)
                  ? MoodleColors.blue
                  : Colors.black,
              bgColor: (_tabController.index == 1)
                  ? MoodleColors.brightGray
                  : MoodleColors.white,
              blurRadius: 3,
              onPressed: () => _tabController.index = 1,
            ),
          ),
        ),
      ],
    );
  }

  void _initBody() {
    _initTabView();
    _initCalendarTabView();
    _initNoteTabView();

    _body = SafeArea(
      child: Column(
        children: [
          Container(height: 16),
          _tabView,
          Expanded(
              child: [_calendarTabView, _noteTabView][_tabController.index]),
        ],
      ),
    );
  }

  // region Calendar tab

  void _initCalendarTabView() {
    _calendarTabView = FutureBuilder(
        future: queryData(),
        builder: (context, data) {
          if (data.hasError) {
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
                setState(() => _events.clear());
              } else {
                timer.cancel();
                _refreshErrorTimer = null;
              }
            });
          } else if (_errored != null) {
            _errored = null;
          }
          return RefreshIndicator(
            onRefresh: () async => setState(() => _events.clear()),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        AnimatedOpacity(
                          opacity: (_events.isEmpty) ? .5 : 1,
                          duration: const Duration(milliseconds: 300),
                          child: IgnorePointer(
                            ignoring: _events.isEmpty,
                            child: _monthView,
                          ),
                        ),
                        AnimatedOpacity(
                            opacity: (data.hasError) ? 1 : 0,
                            duration: const Duration(milliseconds: 300),
                            child: IgnorePointer(
                              ignoring: !data.hasError,
                              child: ErrorCard(
                                  text: AppLocalizations.of(context)!
                                      .err_get_calendar),
                            )),
                        AnimatedOpacity(
                            opacity: (_events.isEmpty) ? 1 : 0,
                            duration: const Duration(milliseconds: 300),
                            child: IgnorePointer(
                                ignoring: _events.isNotEmpty,
                                child: const LoadingCard())),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12, left: 12),
                        child: _dayView,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _initMonthView() {
    _monthView = Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
        child: TableCalendar(
          // Set range and current date
          firstDay: DateTime.utc(2000, 01, 01),
          lastDay: DateTime.utc(2099, 31, 12),
          focusedDay: _focusedDay,

          // Calendar style
          locale: Localizations.localeOf(context).languageCode,
          sixWeekMonthsEnforced: true,
          headerStyle: const HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
              titleTextStyle: TextStyle(
                fontSize: 17,
                decoration: TextDecoration.underline,
              )),
          calendarStyle: const CalendarStyle(
            todayDecoration: BoxDecoration(
              color: MoodleColors.blueLight,
              shape: BoxShape.circle,
            ),
            todayTextStyle: TextStyle(),
            selectedDecoration: BoxDecoration(
              color: MoodleColors.blue,
              shape: BoxShape.circle,
            ),
            markerMargin: EdgeInsets.symmetric(horizontal: 1),
            markerDecoration: BoxDecoration(
              color: MoodleColors.blueDark,
              shape: BoxShape.circle,
            ),
          ),

          // Selecting a date by tapping
          availableGestures: AvailableGestures.none,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(_selectedDay, selectedDay)) {
              _updateFocusedDay(selectedDay, focusedDay);
            }
          },
          onPageChanged: (focusedDay) {
            setState(() {
              _events.clear();
              _focusedDay = focusedDay;
            });
          },
          pageJumpingEnabled: true,
          onHeaderTapped: (_) => _jumpToDate(),

          // Add events from HashMap
          eventLoader: (day) => _getEventsForDay(day),
        ),
      ),
    );
  }

  void _updateFocusedDay(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
      _selectedDay = selectedDay;
      _selectedEvents = _getEventsForDay(selectedDay);
    });
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events[DateFormat.yMd().format(day)] ?? [];
  }

  void _jumpToDate() async {
    _jumpDate = DateTime.now();
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      isDismissible: true,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (_) => Wrap(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  AppLocalizations.of(context)!.jump_date,
                  style: MoodleStyles.bottomSheetTitleStyle,
                ),
              ),
              Container(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: SizedBox(
                  height: 100,
                  child: CupertinoDatePicker(
                    initialDateTime: DateTime.now(),
                    onDateTimeChanged: (value) =>
                        setState(() => _jumpDate = value),
                    mode: CupertinoDatePickerMode.date,
                  ),
                ),
              ),
              Container(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomButtonWidget(
                  onPressed: () {
                    Navigator.pop(context);
                    _updateFocusedDay(_jumpDate, _jumpDate);
                  },
                  textButton: AppLocalizations.of(context)!.jump,
                ),
              ),
              Container(height: 20),
            ],
          ),
        ],
      ),
    );
  }

  void _initDayView() {
    _dayView = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Day view header
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            AppLocalizations.of(context)!.events_on(
                DateFormat.MMMMd(Localizations.localeOf(context).languageCode)
                    .format(_selectedDay)),
            style: MoodleStyles.sectionHeaderStyle,
          ),
        ),

        // Event list
        if (_selectedEvents.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Opacity(
              opacity: .5,
              child: Center(
                child: Text(AppLocalizations.of(context)!.no_events),
              ),
            ),
          ),
        ..._selectedEvents.map((e) {
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
                    final instance = (data.data as ModuleCourse).instance ?? 0;
                    return SubmissionItem(
                      title: title,
                      submissionId: instance,
                      courseId: e.course?.id ?? 0,
                      dueDate: dueDate,
                      isTeacher: null,
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
                    final instance = (data.data as ModuleCourse).instance ?? 0;
                    return QuizItem(
                      title: title,
                      openDate: dueDate,
                      quizInstanceId: instance,
                      courseId: e.course?.id ?? 0,
                      isTeacher: null,
                    );
                  });
            case "":
              return EventItem(
                title: title,
                date: dueDate,
                event: e,
              );
            default:
              return ErrorCard(
                text: 'Unknown module name: ' + (e.modulename ?? ''),
              );
          }
        }).toList(),
      ],
    );
  }

  // endregion

  // region Calendar data fetch

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
      _events = await CalendarService().getEventsByMonth(
        _userStore.user.token,
        _focusedDay,
      );
      _siteInfo = await SiteInfoApi().getSiteInfo(_userStore.user.token);
      _initMonthView();
      _initDayView();
      setState(() {
        _selectedEvents = _getEventsForDay(_selectedDay);
      });
    } catch (e) {
      rethrow;
    }
  }

  // endregion

  // region Note tab

  void _initNoteTabView() {
    if (!hasNoteSection) {
      _noteTabView = Center(
          child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(AppLocalizations.of(context)!.notes_unsupported)));
      return;
    }
    _noteTabView = NoteList(searchShowFlag: noteSearchShowFlag);
  }

  // endregion

  @override
  Widget build(BuildContext context) {
    _initBody();
    return _body;
  }
}
