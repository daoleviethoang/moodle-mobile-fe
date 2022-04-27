import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/view/common/user/course_common.dart';
import 'package:moodle_mobile/view/common/user/public_user_information_common.dart';
import 'package:moodle_mobile/view/common/user/status_common.dart';
import 'package:moodle_mobile/view/common/user/user_detail_common.dart';

/*
UserDetailsScreen(
        avatar:
            'https://meta.vn/Data/image/2021/08/17/con-vit-vang-tren-fb-la-gi-trend-anh-avatar-con-vit-vang-la-gi-3.jpg',
        role: 'Teacher',
        course: 'Đồ án tốt nghiệp',
        email: 'lqvu@fit.hcmus.edu.vn',
        location: 'TP.HCM, Vietnam',
        name: 'Lâm Quang Vũ',
        status: 'Last online 22 hours ago',
      ),
*/

class UserDetailsScreen extends StatefulWidget {
  String avatar;
  String name;
  String status;
  String course;
  String role;
  String email;
  String location;

  UserDetailsScreen(
      {Key? key,
      required this.avatar,
      required this.name,
      required this.status,
      required this.role,
      required this.course,
      required this.email,
      required this.location})
      : super(key: key);

  @override
  _UserDetailsScreen createState() =>
      _UserDetailsScreen(avatar, name, status, role, course, email, location);
}

class _UserDetailsScreen extends State<UserDetailsScreen> {
  String avatar;
  String name;
  String status;
  String course;
  String role;
  String email;
  String location;

  _UserDetailsScreen(this.avatar, this.name, this.status, this.role,
      this.course, this.email, this.location);

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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              PublicInfomationCommonView(
                imageUrl: avatar,
                name: name,
              ),
              StatusCommonView(
                  status: status, color: MoodleColors.grey_icon_status),
              CourseCommonView(
                role: role,
                course: course,
              ),
              UserDetailCommonView(
                email: email,
                location: location,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
