import 'package:moodle_mobile/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:moodle_mobile/view/home/calendar.dart';
import 'package:moodle_mobile/view/home/home.dart';
import 'package:moodle_mobile/view/home/menu.dart';
import 'package:moodle_mobile/view/home/notification_screen.dart';
import 'package:moodle_mobile/view/message/message_screen.dart';

class DirectScreen extends StatefulWidget {
  const DirectScreen({Key? key}) : super(key: key);

  @override
  _DirectScreenState createState() => _DirectScreenState();
}

class _DirectScreenState extends State<DirectScreen> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    CalendarScreen(),
    MessageScreen(),
    NotificationScreen(),
    MenuScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
      title: const Text('Learning Management System',
          textAlign: TextAlign.left,
          style: TextStyle(
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
            onPressed: () {},
          ),
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
          icon: Icon(Icons.calendar_month_outlined),
          activeIcon: Icon(Icons.calendar_month),
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
