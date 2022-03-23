import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moodle_mobile/view/common/menu_item.dart';
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
  var _selectedEvents = <String>[];
  final events = LinkedHashMap(
    equals: isSameDay,
  );

  void _initEvents() {
    final now = DateTime.now();
    events.addAll({
      DateTime.utc(now.year, now.month, 18): ['Do stuffs', 'Do more stuffs'],
      DateTime.utc(now.year, now.month, 16): ['Do things'],
      DateTime.utc(now.year, now.month, 14): ['Do doings'],
    });
  }

  void _initMonthView() {
    _monthView = Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
        child: TableCalendar(
          // Set range and current date
          firstDay: DateTime.utc(2022, 01, 01),
          lastDay: DateTime.utc(2099, 31, 12),
          focusedDay: _focusedDay,

          // Calendar style
          sixWeekMonthsEnforced: true,
          headerStyle: const HeaderStyle(
            titleCentered: true,
            formatButtonVisible: false,
          ),
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              shape: BoxShape.circle,
            ),
            todayTextStyle: const TextStyle(),
            selectedDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            markerDecoration: BoxDecoration(
              color: Theme.of(context).primaryColorDark,
              shape: BoxShape.circle,
            ),
          ),

          // Selecting a date by tapping
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
            _focusedDay = focusedDay;
          },
          pageJumpingEnabled: true,

          // Add events from HashMap
          eventLoader: (day) => _getEventsForDay(day),
        ),
      ),
    );
  }

  List<String> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  void _initDayView() {
    _dayView = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 650),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child:
                Text('Events on ' + DateFormat('MMMM dd').format(_selectedDay),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    )),
          ),
          for (var e in _selectedEvents)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: MenuItem(
                title: e,
                subtitle: DateFormat('dd MMMM, yyyy').format(_selectedDay),
                onPressed: null,
              ),
            ),
        ],
      ),
    );
  }

  @override
  void initState() {
    _initEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _initMonthView();
    _initDayView();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _monthView,
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
  }
}
