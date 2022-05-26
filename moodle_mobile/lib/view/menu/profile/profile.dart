import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/common/user/description_common.dart';
import 'package:moodle_mobile/view/common/user/public_user_information_common.dart';
import 'package:moodle_mobile/view/common/user/user_detail_common.dart';

// class ProfileScreen extends Sta {
//   const ProfileScreen({Key? key}) : super(key: key);

//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

class ProfileScreen extends StatelessWidget {
  UserStore userStore;

  ProfileScreen({Key? key, required this.userStore}) : super(key: key);

  // int _selectedIndex = 0;

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MoodleColors.white,
      appBar: AppBar(
        backgroundColor: MoodleColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              PublicInfomationCommonView(
                imageUrl:
                    userStore.user.photo! + "&token=" + userStore.user.token,
                name: userStore.user.fullname,
                userStore: userStore,
              ),
              UserDetailCommonView(
                email: userStore.user.email,
                location: userStore.user.country != null
                    ? userStore.user.country! + ", "
                    : "" + (userStore.user.city ?? ""),
              ),
              DescriptionCommonView(
                description: userStore.user.description != null
                    ? userStore.user.description!
                    : "",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
