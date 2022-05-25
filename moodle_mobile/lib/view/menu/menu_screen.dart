import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/styles.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/common/content_item.dart';
import 'package:moodle_mobile/view/common/image_view.dart';
import 'package:moodle_mobile/view/common/menu_item.dart' as m;
import 'package:moodle_mobile/view/menu/profile/profile.dart';
import 'package:moodle_mobile/view/message_preference/index.dart';
import 'package:moodle_mobile/view/notification_preference/index.dart';
import 'package:moodle_mobile/view/splash/splash_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late UserStore _userStore;

  @override
  void initState() {
    _userStore = GetIt.instance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              ProfileHeader(userStore: _userStore),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Divider(
                  height: 15,
                  thickness: 1,
                  color: MoodleColors.iconGrey,
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  'News & Info',
                  style: MoodleStyles.sectionHeaderStyle,
                ),
              ),
              const SizedBox(height: 20),
              Card(
                color: Colors.grey[200],
                margin: const EdgeInsets.only(left: 10),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: const [
                      UrlItem(
                        title: 'Hệ thống Q&A FIT',
                        url: 'https://courses.fit.hcmus.edu.vn/q2a',
                      ),
                      SizedBox(height: 8),
                      UrlItem(
                        title: 'Đào tạo sau đại học',
                        url: 'https://www.fit.hcmus.edu.vn/vn/sdh',
                      ),
                      SizedBox(height: 8),
                      UrlItem(
                        title: 'Nghiên cứu khoa học',
                        url:
                            'https://www.fit.hcmus.edu.vn/vn/Default.aspx?tabid=1067',
                      ),
                      SizedBox(height: 8),
                      UrlItem(
                        title: 'Các chương trình theo đề án',
                        url: 'https://www.ctda.hcmus.edu.vn/',
                      ),
                      SizedBox(height: 8),
                      UrlItem(
                        title: 'Giảng dạy tại FIT.HCMUS',
                        url: 'https://teaching.fit.hcmus.edu.vn/',
                      ),
                      SizedBox(height: 8),
                      UrlItem(
                        title: 'Moodle FAQS',
                        url: 'https://courses.fit.hcmus.edu.vn/faq/',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  'Settings',
                  style: MoodleStyles.sectionHeaderStyle,
                ),
              ),
              const SizedBox(height: 20),
              Card(
                color: Colors.grey[200],
                margin: const EdgeInsets.only(left: 10),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      m.MenuItem(
                        title: 'Notifications & sounds',
                        color: Colors.amber,
                        icon: const Icon(Icons.notifications_rounded),
                        fullWidth: true,
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (_) {
                            return const NotificationPreferenceScreen();
                          }));
                        },
                      ),
                      const SizedBox(height: 8),
                      m.MenuItem(
                        title: 'Message notification',
                        color: Colors.amber,
                        icon: const Icon(Icons.messenger_rounded),
                        fullWidth: true,
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (_) {
                            return const MessagePreferenceScreen();
                          }));
                        },
                      ),
                      const SizedBox(height: 8),
                      m.MenuItem(
                        title: 'Moodle Settings',
                        color: Colors.blueGrey,
                        icon: const Icon(Icons.school_rounded),
                        fullWidth: true,
                        onPressed: () {},
                      ),
                      const SizedBox(height: 8),
                      m.MenuItem(
                        title: 'App Theme',
                        color: Colors.purple.shade200,
                        icon: const Icon(Icons.lightbulb_rounded),
                        fullWidth: true,
                        onPressed: () {},
                      ),
                      const SizedBox(height: 8),
                      m.MenuItem(
                        title: 'Device Permissions',
                        color: Colors.green,
                        icon: const Icon(Icons.lock_rounded),
                        fullWidth: true,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  'Account',
                  style: MoodleStyles.sectionHeaderStyle,
                ),
              ),
              const SizedBox(height: 20),
              Card(
                color: Colors.grey[200],
                margin: const EdgeInsets.only(left: 10),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      m.MenuItem(
                        title: 'Change password',
                        color: Colors.blue,
                        icon: const Icon(Icons.password_rounded),
                        fullWidth: true,
                        onPressed: () {},
                      ),
                      const SizedBox(height: 8),
                      m.MenuItem(
                        title: 'Report a problem',
                        color: Colors.red,
                        icon: const Icon(Icons.campaign_rounded),
                        fullWidth: true,
                        onPressed: () {},
                      ),
                      const SizedBox(height: 8),
                      m.MenuItem(
                        title: 'Logout',
                        color: Colors.grey,
                        icon: const Icon(Icons.logout_rounded),
                        fullWidth: true,
                        onPressed: () async {
                          _userStore.logout();
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(builder: (_) {
                            return const SplashScreen();
                          }));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    Key? key,
    required UserStore userStore,
  })  : _userStore = userStore,
        super(key: key);

  final UserStore _userStore;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => const ProfileScreen(),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleImageView(
              fit: BoxFit.none,
              imageUrl:
                  _userStore.user.photo! + "&token=" + _userStore.user.token,
              placeholder: CircularProgressIndicator()),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                _userStore.user.fullname,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _userStore.user.email,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData iconName;
  final String name;
  final Color iconColor;

  const MenuButton({
    Key? key,
    required this.onTap,
    required this.name,
    required this.iconName,
    required this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: iconColor,
            child: Icon(
              iconName,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            name,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
