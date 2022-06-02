import 'package:flutter/material.dart';
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
      this.courseName,
      required this.avatar})
      : super(key: key);

  final String fullname;
  final int id;
  final int? role;
  final UserStore userStore;
  final String? courseName;
  final String avatar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListTile(
        leading: SizedBox(
          width: 60.0,
          height: 60.0,
          child: CircleImageView(
            fit: BoxFit.cover,
            imageUrl: avatar + "&token=" + userStore.user.token,
            placeholder: const Icon(
              Icons.person_outline,
              size: 32,
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
          onClick: () => {},
        ),
        title: Text(fullname),
        onTap: () => {
          if (role != null && role != 5)
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
