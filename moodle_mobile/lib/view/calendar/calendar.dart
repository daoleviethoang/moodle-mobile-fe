import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:moodle_mobile/constants/styles.dart';
import 'package:moodle_mobile/data/network/apis/calendar/calendar_service.dart';
import 'package:moodle_mobile/data/network/apis/module/module_service.dart';
import 'package:moodle_mobile/models/calendar/event.dart';
import 'package:moodle_mobile/models/module/module.dart';
import 'package:moodle_mobile/models/module/module_course.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/common/content_item.dart';
import 'package:moodle_mobile/view/common/custom_button.dart';
import 'package:moodle_mobile/view/common/data_card.dart';
import 'package:moodle_mobile/view/common/menu_item.dart';
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

class _CalendarScreenState extends State<CalendarScreen> {
  Widget _monthView = Container();
  Widget _dayView = Container();

  var _jumpDate = DateTime.now();
  var _selectedDay = DateTime.now();
  var _focusedDay = DateTime.now();
  var _selectedEvents = <Event>[];

  late UserStore _userStore;
  Map<String, List<Event>> _events = {};
  Observable<bool>? _jumpOpenFlag;

  @override
  void initState() {
    super.initState();
    _userStore = GetIt.instance<UserStore>();
    _jumpOpenFlag = widget.jumpOpenFlag;
    _jumpOpenFlag?.observe((p0) {
      if (_jumpOpenFlag?.value ?? false) {
        _jumpOpenFlag?.toggle();
        _jumpToDate();
      }
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
                child: Text(AppLocalizations.of(context)!.jump_date,
                    style: const TextStyle(fontSize: 20)),
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
    _dayView = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 500),
      child: Column(
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
                      final instance =
                          (data.data as ModuleCourse).instance ?? 0;
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
                      final instance =
                          (data.data as ModuleCourse).instance ?? 0;
                      return QuizItem(
                        title: title,
                        openDate: dueDate,
                        quizInstanceId: instance,
                        courseId: e.course?.id ?? 0,
                        isTeacher: null,
                      );
                    });
              case "":
                return MenuItem(
                  icon: const Icon(CupertinoIcons.calendar),
                  color: MoodleColors.blue,
                  title: title,
                  subtitle: DateFormat('HH:mm, dd MMMM, yyyy').format(dueDate),
                  fullWidth: true,
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      builder: (builder) => Container(
                        height: 300,
                        padding: const EdgeInsets.only(
                            top: 8, bottom: 20, left: 10, right: 10),
                        decoration: const BoxDecoration(
                          color: MoodleColors.grey_bottom_bar,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Container(
                              height: 30,
                              child: Text(
                                e.name ?? "No name",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                textScaleFactor: 1.8,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 230,
                              padding: const EdgeInsets.only(
                                  left: Dimens.default_padding,
                                  right: Dimens.default_padding),
                              child:
                                  Html(data: e.description ?? "No description"),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                      Dimens.default_border_radius * 3),
                                ),
                                color: MoodleColors.brightGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              default:
                return ErrorCard(
                  text: 'Unknown module name: ' + (e.modulename ?? ''),
                );
            }
          }).toList(),
        ],
      ),
    );
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
      _events = await CalendarService().getEventsByMonth(
        _userStore.user.token,
        _focusedDay,
      );
      _initMonthView();
      _initDayView();
      setState(() {
        _selectedEvents = _getEventsForDay(_selectedDay);
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
          future: queryData(),
          builder: (context, data) {
            if (data.hasError) {
              if (kDebugMode) {
                print('${data.error}');
              }
              return ErrorCard(
                  text: AppLocalizations.of(context)!.err_get_calendar);
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
                              opacity: (_events.isEmpty) ? 1 : 0,
                              duration: const Duration(milliseconds: 300),
                              child:
                                  const CircularProgressIndicator.adaptive()),
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
          }),
    );
  }
}
