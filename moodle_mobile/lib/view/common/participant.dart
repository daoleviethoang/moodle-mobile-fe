import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:moodle_mobile/models/conversation/conversation_message.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/common/image_view.dart';
import 'package:moodle_mobile/view/user_detail/user_detail.dart';
import 'package:moodle_mobile/view/user_detail/user_detail_student.dart';

class ParticipantListTile extends StatelessWidget {
  const ParticipantListTile(
      {Key? key,
      required this.fullname,
      required this.id,
      this.role,
      required this.userStore,
      this.courseName})
      : super(key: key);

  final String fullname;
  final int id;
  final int? role;
  final UserStore userStore;
  final String? courseName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListTile(
        leading: SizedBox(
          width: 60,
          height: 60,
          child: CircleAvatar(
            radius: 20,
            backgroundColor: MoodleColors.blue,
            child: Icon(
              Icons.person,
              size: 40,
              color: Colors.white,
            ),
          ),
        ),
        trailing: RoundedImageView(
          color: Colors.transparent,
          imageUrl: 'user-avatar-url',
          placeholder: Image.asset(
            'assets/image/Icon.png',
            width: 50,
            height: 50,
          ),
          onClick: () => {print("123")},
          //  Icon(
          //   Icons.messenger_outline,
          //   size: 36,
          //   color: Colors.black,
          // ),
        ),
        title: Text(fullname),
        onTap: () => {
          if (role != 5)
            {
              Navigator.push<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => UserDetailsScreen(
                      id: id, userStore: userStore, courseName: courseName),
                ),
              )
            }
          else
            {
              Navigator.push<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => UserDetailStudentScreen(
                      id: id, userStore: userStore, courseName: courseName),
                ),
              )
            }
        },
      ),
    );
    ;
  }
}
