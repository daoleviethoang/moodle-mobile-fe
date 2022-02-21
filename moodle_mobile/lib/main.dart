import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

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

class CalendarSubPage extends StatefulWidget {
  const CalendarSubPage({Key? key}) : super(key: key);

  @override
  State<CalendarSubPage> createState() => _CalendarSubPageState();
}

class _CalendarSubPageState extends State<CalendarSubPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Calendar'));
  }
}

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