import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/menu/profile/profile.dart';

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
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //     title: Text(
      //   'Learning Management System',
      //   style: TextStyle(color: Colors.white),
      // )),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ProfileHeader(userStore: _userStore),
            ),
            Container(
              margin: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Divider(
                height: 15,
                thickness: 1,
                color: Colors.red,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 10, bottom: 10),
              child: Text('News & Info',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ),
            Container(
              color: Colors.grey[200],
              margin: EdgeInsets.only(top: 10, left: 10),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              //padding: EdgeInsets.only(bottom: 15),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MenuButton(
                      onTap: () {},
                      iconColor: Colors.purple.shade300,
                      name: 'Moodle FAQS',
                      iconName: Icons.link,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    MenuButton(
                      onTap: () {},
                      iconColor: Colors.purple.shade300,
                      name: 'Giang day tai FIT.HCMUS',
                      iconName: Icons.account_circle,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    MenuButton(
                      onTap: () {},
                      iconColor: Colors.purple.shade300,
                      name: 'Cac chuong trinh theo de an',
                      iconName: Icons.link,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    MenuButton(
                      onTap: () {},
                      iconColor: Colors.purple.shade300,
                      name: 'Dao tao sau dai hoc',
                      iconName: Icons.link,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    MenuButton(
                      onTap: () {},
                      iconColor: Colors.purple.shade300,
                      name: 'Nghien cuu khoa hoc',
                      iconName: Icons.link,
                    ),
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 10, bottom: 10),
              child: Text('Settings',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ),
            Container(
              color: Colors.grey[200],
              margin: EdgeInsets.only(top: 10, left: 10),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              //padding: EdgeInsets.only(bottom: 15),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MenuButton(
                      onTap: () {},
                      iconColor: Colors.amber,
                      name: 'Notifications & sounds',
                      iconName: Icons.circle_notifications,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    MenuButton(
                      onTap: () {},
                      iconColor: Colors.blueGrey,
                      name: 'Moodle Settings',
                      iconName: Icons.account_circle,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    MenuButton(
                      onTap: () {},
                      iconColor: Colors.purple.shade200,
                      name: 'App Theme',
                      iconName: CupertinoIcons.circle_righthalf_fill,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    MenuButton(
                      onTap: () {},
                      iconColor: Colors.green,
                      name: 'Device Permisson',
                      iconName: CupertinoIcons.lock_circle_fill,
                    ),
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 10, bottom: 10),
              child: Text('Account',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ),
            Container(
              color: Colors.grey[200],
              margin: EdgeInsets.only(top: 10, left: 10),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              //padding: EdgeInsets.only(bottom: 15),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MenuButton(
                      onTap: () {},
                      iconColor: Colors.blue,
                      name: 'Change password',
                      iconName: Icons.password_outlined,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    MenuButton(
                      onTap: () {},
                      iconColor: Colors.red,
                      name: 'Report a problem',
                      iconName: Icons.campaign_rounded,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    MenuButton(
                      onTap: () {},
                      iconColor: Colors.purple.shade200,
                      name: 'App Theme',
                      iconName: Icons.chat_bubble,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    MenuButton(
                      onTap: () {
                        //Navigator.pop(context);
                      },
                      iconColor: Colors.grey,
                      name: 'Log out',
                      iconName: Icons.logout_outlined,
                    ),
                  ]),
            ),
          ]),
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
          CircleAvatar(
            radius: 23,
          ),
          SizedBox(
            width: 5,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                _userStore.user.fullname,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              Text(
                _userStore.user.email,
                style: TextStyle(
                    color: Colors.grey, decoration: TextDecoration.underline),
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
          SizedBox(
            width: 8,
          ),
          Text(
            name,
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
