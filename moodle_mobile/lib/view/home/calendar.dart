import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/data/network/apis/calendar/calendar_service.dart';
import 'package:moodle_mobile/models/calendar/calendar.dart';
import 'package:moodle_mobile/models/calendar/day.dart';
import 'package:moodle_mobile/models/calendar/event.dart';
import 'package:moodle_mobile/models/calendar/week.dart';
import 'package:moodle_mobile/models/module/module.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/common/content_item.dart';
import 'package:moodle_mobile/view/common/data_card.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late Widget _monthView;
  late Widget _dayView;

  var _selectedDay = DateTime.now();
  var _focusedDay = DateTime.now();
  var _selectedEvents = <Event>[];

  late UserStore _userStore;
  Calendar? _calendar;

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
          ),
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
              setState(() {
                _focusedDay = focusedDay;
                _selectedDay = selectedDay;
                _selectedEvents = _getEventsForDay(selectedDay);
              });
            }
          },
          onPageChanged: (focusedDay) {
            setState(() {
              _calendar = null;
              _focusedDay = focusedDay;
            });
          },
          pageJumpingEnabled: true,

          // Add events from HashMap
          eventLoader: (day) => _getEventsForDay(day),
        ),
      ),
    );
  }

  List<Event> _getEventsForDay(DateTime day) {
    final events = <Event>[];
    for (Week w in _calendar?.weeks ?? []) {
      for (Day d in w.days ?? []) {
        DateTime dt =
            DateTime.fromMillisecondsSinceEpoch((d.timestamp ?? 0) * 1000);
        if (isSameDay(dt, day)) {
          events.addAll(d.events ?? []);
        }
      }
    }
    return events.toSet().toList();
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
            final dueDate =
                DateTime.fromMillisecondsSinceEpoch((e.timestart ?? 0) * 1000);
            switch (e.modulename ?? '') {
              case ModuleName.assign:
                return SubmissionItem(
                  title: title,
                  submissionId: '${e.instance ?? 0}',
                  dueDate: dueDate,
                );
              case ModuleName.quiz:
                return QuizItem(
                  title: title,
                  openDate: dueDate,
                  quizId: '${e.instance ?? 0}',
                );
              default:
                throw Exception('Unknown module name: ' + (e.modulename ?? ''));
            }
          }).toList()
        ],
      ),
    );
  }

  Future queryData() async {
    try {
      _calendar = await CalendarService().getCalendarByRange(
        _userStore.user.token,
        _focusedDay,
        range: 0,
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
                        opacity: (_calendar == null) ? .5 : 1,
                        duration: const Duration(milliseconds: 300),
                        child: IgnorePointer(
                          ignoring: _calendar == null,
                          child: _monthView,
                        ),
                      ),
                      AnimatedOpacity(
                          opacity: (_calendar == null) ? 1 : 0,
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