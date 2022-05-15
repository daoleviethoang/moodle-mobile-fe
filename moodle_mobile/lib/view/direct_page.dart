import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:moodle_mobile/models/course/courses.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/calendar/calendar.dart';
import 'package:moodle_mobile/view/home/home.dart';
import 'package:moodle_mobile/view/menu/menu_screen.dart';
import 'package:moodle_mobile/view/notifications/notification_screen.dart';
import 'package:moodle_mobile/view/message/message_screen.dart';
import 'package:moodle_mobile/view/search_course/search_course.dart';

class DirectScreen extends StatefulWidget {
  const DirectScreen({Key? key}) : super(key: key);

  @override
  _DirectScreenState createState() => _DirectScreenState();
}

class _DirectScreenState extends State<DirectScreen> {
  int _selectedIndex = 0;
  late UserStore _userStore;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    CalendarScreen(),
    MessageScreen(),
    NotificationScreen(),
    MenuScreen(),
  ];
  static const List<String> _widgetAppBarTitle = <String>[
    "Learning Management System",
    "Calendar",
    "Messenger",
    "Notifications",
    "Menu",
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    _userStore = GetIt.instance<UserStore>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getRedirectUI();
  }

  Widget getRedirectUI() {
    return Scaffold(
      appBar: getAppBarUI(),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: getBottomNavBarUI(),
    );
  }

  AppBar getAppBarUI() {
    return AppBar(
      title: Text(_widgetAppBarTitle.elementAt(_selectedIndex),
          textAlign: TextAlign.left,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              letterSpacing: 1,
              color: MoodleColors.white)),
      actions: <Widget>[
        SizedBox(
          width: 60,
          height: 60,
          child: IconButton(
              iconSize: 40,
              icon: const Icon(Icons.search),
              color: MoodleColors.white,
              onPressed: () async {
                await showSearch<CourseOverview?>(
                  context: context,
                  delegate: CoursesSearch(token: _userStore.user.token),
                );
              }),
        )
      ],
    );
  }

  BottomNavigationBar getBottomNavBarUI() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home_rounded),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event_outlined),
          activeIcon: Icon(Icons.event_rounded),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.messenger_outline_rounded),
          activeIcon: Icon(Icons.messenger_rounded),
          label: 'Messenger',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_outlined),
          activeIcon: Icon(Icons.notifications),
          label: 'Notification',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_rounded),
          label: 'Menu',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: MoodleColors.blue,
      onTap: _onItemTapped,
    );
  }
}