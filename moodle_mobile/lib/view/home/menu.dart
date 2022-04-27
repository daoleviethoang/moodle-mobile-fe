import 'package:flutter/material.dart';
import 'package:moodle_mobile/view/menu/profile/profile.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          //width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.circle,
                      size: 50,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Tran Dinh Phat',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '18127177@student.hcmus.edu.vn',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    )
                  ],
                ),
                onTap: () => Navigator.push<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => const ProfileScreen(),
                  ),
                ),
              ),
              const Divider(
                color: Colors.grey,
              ),
              const SizedBox(height: 8),
              const Text('Settings',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              const SizedBox(height: 8),
              Settings(),
              const SizedBox(height: 8),
              const Text('Account',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              const SizedBox(height: 8),
              const Account()
            ],
          ),
        ),
      ),
    );
  }
}

class Account extends StatelessWidget {
  const Account({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      padding: const EdgeInsets.only(left: 10, top: 10),
      //color: Colors.grey,
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: const [
                Icon(
                  Icons.circle_notifications_outlined,
                  size: 35,
                  color: Colors.blue,
                ),
                SizedBox(
                  width: 8,
                ),
                Text('Change a password'),
              ],
            ),
          ),
          //SizedBox(
          //   height: MediaQuery.of(context).size.height * 0.3 * 0.02),
          Expanded(
            child: Row(
              children: const [
                Icon(
                  Icons.circle_notifications_outlined,
                  color: Colors.red,
                  size: 35,
                ),
                SizedBox(
                  width: 8,
                ),
                Text('Report a problem'),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: const [
                Icon(
                  Icons.circle_notifications_outlined,
                  color: Colors.blueGrey,
                  size: 35,
                ),
                SizedBox(
                  width: 8,
                ),
                Text('Contact help'),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: const [
                Icon(
                  Icons.circle_notifications_outlined,
                  color: Colors.grey,
                  size: 35,
                ),
                SizedBox(
                  width: 8,
                ),
                Text('Log out'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      padding: const EdgeInsets.only(left: 10, top: 10),
      //color: Colors.grey,
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                const Icon(
                  Icons.circle_notifications_outlined,
                  size: 35,
                  color: Colors.purple,
                ),
                const SizedBox(
                  width: 8,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'App Theme',
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Follow system',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                )
              ],
            ),
          ),
          //SizedBox(
          //   height: MediaQuery.of(context).size.height * 0.3 * 0.02),
          Expanded(
            child: Row(
              children: const [
                Icon(
                  Icons.circle_notifications_outlined,
                  color: Colors.orange,
                  size: 35,
                ),
                SizedBox(
                  width: 8,
                ),
                Text('Notifications & sounds'),
              ],
            ),
          ),

          Expanded(
            child: Row(
              children: const [
                Icon(
                  Icons.circle_notifications_outlined,
                  color: Colors.green,
                  size: 35,
                ),
                SizedBox(
                  width: 8,
                ),
                Text('Device permissions'),
              ],
            ),
          ),

          Expanded(
            child: Row(
              children: const [
                Icon(
                  Icons.circle_notifications_outlined,
                  color: Colors.blue,
                  size: 35,
                ),
                SizedBox(
                  width: 8,
                ),
                Text('Moodle settings'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
