import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moodle_mobile/screens/login.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Learning Management System',
        style: TextStyle(color: Colors.white),
      )),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
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
                      'Tran Dinh Phat',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '18127177@student.hcmus.edu.vn',
                      style: TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.underline),
                    ),
                  ],
                ),
              ],
            ),
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
                    onTap: () {},
                    iconColor: Colors.grey,
                    name: 'Log out',
                    iconName: Icons.logout_outlined,
                  ),
                ]),
          ),
        ]),
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
