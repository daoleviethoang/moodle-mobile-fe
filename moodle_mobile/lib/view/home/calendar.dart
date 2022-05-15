import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/data/network/apis/calendar/calendar_service.dart';
import 'package:moodle_mobile/data/network/apis/module/module_service.dart';
import 'package:moodle_mobile/models/calendar/event.dart';
import 'package:moodle_mobile/models/module/module.dart';
import 'package:moodle_mobile/models/module/module_course.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/common/content_item.dart';
import 'package:moodle_mobile/view/common/custom_button.dart';
import 'package:moodle_mobile/view/common/data_card.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

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

  @override
  void initState() {
    super.initState();
    _userStore = GetIt.instance<UserStore>();
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('Jump to date', style: TextStyle(fontSize: 20)),
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
                  textButton: 'Jump',
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
            child:
                Text('Events on ' + DateFormat('MMMM dd').format(_selectedDay),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    )),
          ),

          // Event list
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
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: queryData(),
        builder: (context, data) {
          if (data.hasError) {
            return ErrorCard(text: '${data.error}');
          }
          return SingleChildScrollView(
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
                          child: const CircularProgressIndicator.adaptive()),
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
          );
        });
  }
}