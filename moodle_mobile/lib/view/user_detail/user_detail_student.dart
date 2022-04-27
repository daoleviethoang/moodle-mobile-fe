import 'dart:html';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/view/common/user/course_common.dart';
import 'package:moodle_mobile/view/common/user/description_common.dart';
import 'package:moodle_mobile/view/common/user/public_user_information_common.dart';
import 'package:moodle_mobile/view/common/user/status_common.dart';
import 'package:moodle_mobile/view/common/user/user_detail_common.dart';

class UserDetailStudentScreen extends StatefulWidget {
  String avatar;
  String name;
  String status;
  String course;
  String role;
  String email;
  String location;

  UserDetailStudentScreen(
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
  _UserDetailStudentScreen createState() => _UserDetailStudentScreen(
      avatar, name, status, role, course, email, location);
}

class _UserDetailStudentScreen extends State<UserDetailStudentScreen> {
  String avatar;
  String name;
  String status;
  String course;
  String role;
  String email;
  String location;

  _UserDetailStudentScreen(this.avatar, this.name, this.status, this.role,
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
          icon: Icon(Icons.arrow_back, color: Colors.black),
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
                  status: status, color: MoodleColors.green_icon_status),
              CourseCommonView(
                role: role,
                course: course,
              ),
              UserDetailCommonView(
                email: email,
                location: location,
              ),
              const DescriptionCommonView(
                description:
                    'At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
