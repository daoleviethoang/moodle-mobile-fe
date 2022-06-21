import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:moodle_mobile/constants/styles.dart';
import 'package:moodle_mobile/data/firebase/messaging/messaging_helper.dart';
import 'package:moodle_mobile/models/course/courses.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/calendar/calendar.dart';
import 'package:moodle_mobile/view/home/home.dart';
import 'package:moodle_mobile/view/menu/menu_screen.dart';
import 'package:moodle_mobile/view/message_preference/index.dart';
import 'package:moodle_mobile/view/notification_preference/index.dart';
import 'package:moodle_mobile/view/notifications/notification_screen.dart';
import 'package:moodle_mobile/view/message/message_screen.dart';
import 'package:moodle_mobile/view/search_course/search_course.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DirectScreen extends StatefulWidget {
  const DirectScreen({Key? key}) : super(key: key);

  @override
  _DirectScreenState createState() => _DirectScreenState();
}

class _DirectScreenState extends State<DirectScreen> {
  late int _selectedIndex = 0;
  late UserStore _userStore;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  // ignore: prefer_final_fields
  List<Widget> _widgetOptions = [];
  static late List<String> _widgetAppBarTitle;
  final calendarJumpOpenFlag = ObservableBool(false);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _userStore = GetIt.instance<UserStore>();

    setState(() {
      _widgetOptions = <Widget>[
        const HomeScreen(),
        CalendarScreen(jumpOpenFlag: calendarJumpOpenFlag),
        const MessageScreen(),
        const NotificationScreen(),
        const MenuScreen(),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check notification permission for FCM
    MessagingHelper.checkPermission(context);

    _widgetAppBarTitle = [
      "Learning Management System",
      AppLocalizations.of(context)!.planning,
      AppLocalizations.of(context)!.messenger,
      AppLocalizations.of(context)!.notifications,
      AppLocalizations.of(context)!.menu,
    ];

    return getRedirectUI();
  }

  Widget getRedirectUI() {
    return Scaffold(
      extendBody: true,
      appBar: getAppBarUI(),
      body: Center(
        child: IndexedStack(
          children: _widgetOptions,
          index: _selectedIndex,
        ),
      ),
      bottomNavigationBar: getBottomNavBarUI(),
    );
  }

  AppBar getAppBarUI() {
    return AppBar(
      title: Text(_widgetAppBarTitle.elementAt(_selectedIndex),
          textAlign: TextAlign.left, style: MoodleStyles.appBarTitleStyle),
      actions: <Widget>[
        Builder(
          builder: (context) {
            switch (_selectedIndex) {
              case 0:
                return IconButton(
                    iconSize: Dimens.appbar_icon_size,
                    icon: const Icon(Icons.search),
                    onPressed: () async {
                      await showSearch<CourseOverview?>(
                        context: context,
                        delegate: CoursesSearch(token: _userStore.user.token),
                      );
                    });
              case 1:
                return IconButton(
                    iconSize: Dimens.appbar_icon_size,
                    icon: const Icon(Icons.search),
                    onPressed: () => calendarJumpOpenFlag.toggle());
              case 2:
                return IconButton(
                    iconSize: Dimens.appbar_icon_size,
                    icon: const Icon(Icons.settings),
                    onPressed: () async {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return const MessagePreferenceScreen();
                      }));
                    });
              case 3:
                return IconButton(
                    iconSize: Dimens.appbar_icon_size,
                    icon: const Icon(Icons.settings),
                    onPressed: () async {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return const NotificationPreferenceScreen();
                      }));
                    });
              default:
                return Container();
            }
          }
        ),
      ],
    );
  }

  BottomNavigationBar getBottomNavBarUI() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_outlined),
          activeIcon: const Icon(Icons.home_rounded),
          label: AppLocalizations.of(context)!.dashboard,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.event_outlined),
          activeIcon: const Icon(Icons.event_rounded),
          label: _widgetAppBarTitle[1],
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.messenger_outline_rounded),
          activeIcon: const Icon(Icons.messenger_rounded),
          label: _widgetAppBarTitle[2],
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.notifications_outlined),
          activeIcon: const Icon(Icons.notifications),
          label: _widgetAppBarTitle[3],
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.menu_rounded),
          label: _widgetAppBarTitle[4],
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: MoodleColors.blue,
      onTap: _onItemTapped,
    );
  }
}