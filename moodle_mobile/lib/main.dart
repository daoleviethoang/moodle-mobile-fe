import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,

        /// Theme for all cards in this app
        cardTheme: CardTheme(
          color: Theme.of(context).colorScheme.surface,
          elevation: 8,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

// region HOME PAGE

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _index = 0;
  late List<Widget> _body;

  /// List of widgets to show on navigation bar item pressed
  void _initBody() {
    _body = [
      const DashboardSubPage(),
      const CalendarSubPage(),
      const MessengerSubPage(),
      const NotificationSubPage(),
      const MenuSubPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    _initBody();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _body[_index],

      /// Navigation bar with 5 items
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .surface,
          currentIndex: _index,
          onTap: (value) => setState(() => _index = value),
          selectedIconTheme:
          IconThemeData(size: Theme
              .of(context)
              .iconTheme
              .size ?? 24 * 1.25),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.house),
              activeIcon: Icon(CupertinoIcons.house_fill),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.calendar),
              activeIcon: Icon(CupertinoIcons.calendar_today),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.chat_bubble),
              activeIcon: Icon(CupertinoIcons.chat_bubble_fill),
              label: 'Messenger',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.bell),
              activeIcon: Icon(CupertinoIcons.bell_solid),
              label: 'Notification',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.ellipsis),
              activeIcon: Icon(CupertinoIcons.ellipsis),
              label: 'Menu',
            ),
          ]),
    );
  }
}

// endregion


// region DASHBOARD

class DashboardSubPage extends StatefulWidget {
  const DashboardSubPage({Key? key}) : super(key: key);

  @override
  State<DashboardSubPage> createState() => _DashboardSubPageState();
}

class _DashboardSubPageState extends State<DashboardSubPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Dashboard'));
  }
}

// endregion


// region CALENDAR

class CalendarSubPage extends StatefulWidget {
  const CalendarSubPage({Key? key}) : super(key: key);

  @override
  State<CalendarSubPage> createState() => _CalendarSubPageState();
}

class _CalendarSubPageState extends State<CalendarSubPage> {
  var _selectedDay = DateTime.now();
  var _focusedDay = DateTime.now();
  var _selectedEvents = <String>[];
  final events = LinkedHashMap(
    equals: isSameDay,
  );

  void _initEvents() {
    events.addAll({
      DateTime.utc(2022, 02, 18): ['Do stuffs', 'Do more stuffs'],
      DateTime.utc(2022, 02, 16): ['Do things'],
      DateTime.utc(2022, 02, 14): ['Do doings'],
    });
  }

  Widget _monthView() {
    return Card(
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
  
  Widget _dayView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Events on ' + _selectedDay.toString().split('00:')[0],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          )),
        Text(_selectedEvents.toString()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _initEvents();

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          _monthView(),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 12, left: 12),
              child: _dayView(),
            ),
          ),
        ],
      ),
    );
  }
}

// endregion


// region MESSENGER

class MessengerSubPage extends StatefulWidget {
  const MessengerSubPage({Key? key}) : super(key: key);

  @override
  State<MessengerSubPage> createState() => _MessengerSubPageState();
}

class _MessengerSubPageState extends State<MessengerSubPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Messenger'));
  }
}

// endregion


// region NOTIFICATION

class NotificationSubPage extends StatefulWidget {
  const NotificationSubPage({Key? key}) : super(key: key);

  @override
  State<NotificationSubPage> createState() => _NotificationSubPageState();
}

class _NotificationSubPageState extends State<NotificationSubPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Notification'));
  }
}

// endregion


// region MENU

class MenuSubPage extends StatefulWidget {
  const MenuSubPage({Key? key}) : super(key: key);

  @override
  State<MenuSubPage> createState() => _MenuSubPageState();
}

class _MenuSubPageState extends State<MenuSubPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Menu'));
  }
}

// endregion