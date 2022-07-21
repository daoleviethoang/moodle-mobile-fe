import 'package:flutter/material.dart';
import 'package:moodle_mobile/data/repository.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/common/image_view.dart';
import 'package:moodle_mobile/view/common/user/user_avatar_common.dart';
import 'package:moodle_mobile/view/message/message_detail_screen.dart';
import 'package:moodle_mobile/view/user_detail/user_detail.dart';
import 'package:moodle_mobile/view/user_detail/user_detail_student.dart';

class ParticipantListTile extends StatelessWidget {
  const ParticipantListTile(
      {Key? key,
      required this.fullname,
      required this.id,
      this.role,
      required this.userStore,
      required this.repository,
      required this.context,
      this.courseName,
      this.conversationId,
      required this.avatar})
      : super(key: key);

  final String fullname;
  final int id;
  final int? role;
  final UserStore userStore;
  final String? courseName;
  final String avatar;
  final Repository repository;
  final BuildContext context;
  final int? conversationId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListTile(
        leading: UserAvatarCommon(
          imageURL: avatar + "&token=" + userStore.user.token,
        ),
        trailing: RoundedImageView(
          color: Colors.transparent,
          imageUrl: 'user-avatar-url',
          placeholder: Image.asset(
            'assets/image/Icon.png',
            width: 50,
            height: 50,
          ),
          onClick: () async {
            if (conversationId == null) {
              var newConversationId = await getConversationIdByUserId(id);
              Navigator.push<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => MessageDetailScreen(
                      conversationId: newConversationId,
                      userFrom: fullname,
                      userFromId: id),
                ),
              );
            } else {
              Navigator.push<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => MessageDetailScreen(
                      conversationId: conversationId,
                      userFrom: fullname,
                      userFromId: id),
                ),
              );
            }
          },
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
  }

  Future<int?> getConversationIdByUserId(int userIdFrom) async {
    try {
      int? conversationId = await repository.getConversationIdByUserId(
          userStore.user.token, userStore.user.id, userIdFrom);

      return conversationId;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));

      return null;
    }
  }
}
