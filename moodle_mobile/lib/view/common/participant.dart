import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:moodle_mobile/models/conversation/conversation_message.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:moodle_mobile/view/common/image_view.dart';
import 'package:moodle_mobile/view/user_detail/user_detail.dart';
import 'package:moodle_mobile/view/user_detail/user_detail_student.dart';

class ParticipantListTile extends StatelessWidget {
  const ParticipantListTile(
      {Key? key, required this.fullname, required this.index})
      : super(key: key);

  final String fullname;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListTile(
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: MoodleColors.blue,
          child: Icon(
            Icons.person,
            size: 25,
            color: Colors.white,
          ),
        ),
        trailing: const RoundedImageView(
          color: Colors.white,
          imageUrl: 'user-avatar-url',
          placeholder: Icon(
            Icons.messenger_outline,
            size: 36,
            color: Colors.black,
          ),
        ),
        title: Text(fullname),
        onTap: () => {
          if (index == 0)
            {
              Navigator.push<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => UserDetailsScreen(
                    avatar:
                        'https://meta.vn/Data/image/2021/08/17/con-vit-vang-tren-fb-la-gi-trend-anh-avatar-con-vit-vang-la-gi-3.jpg',
                    role: 'Teacher',
                    course: 'Đồ án tốt nghiệp',
                    email: 'lqvu@fit.hcmus.edu.vn',
                    location: 'TP.HCM, Vietnam',
                    name: fullname,
                    status: 'Last online 22 hours ago',
                  ),
                ),
              )
            }
          else
            {
              Navigator.push<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => UserDetailStudentScreen(
                    avatar:
                        'https://meta.vn/Data/image/2021/08/17/con-vit-vang-tren-fb-la-gi-trend-anh-avatar-con-vit-vang-la-gi-3.jpg',
                    role: 'Student',
                    course: 'Đồ án tốt nghiệp',
                    email: '18127044@student.hcmus.edu.vn',
                    location: 'TP.HCM, Vietnam',
                    name: fullname,
                    status: 'Online just now',
                  ),
                ),
              )
            }
        },
      ),
    );
    ;
  }
}
