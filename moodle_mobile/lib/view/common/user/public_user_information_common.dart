import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
import 'package:moodle_mobile/view/common/image_view.dart';
import 'package:moodle_mobile/view/message/message_detail_screen.dart';

class PublicInfomationCommonView extends StatelessWidget {
  final String imageUrl;
  final String name;
  final UserStore userStore;

  const PublicInfomationCommonView(
      {Key? key,
      required this.imageUrl,
      required this.name,
      required this.userStore})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 159.0,
          height: 159.0,
          child: CircleImageView(
              fit: BoxFit.cover,
              imageUrl: imageUrl + "&token=" + userStore.user.token,
              placeholder: CircularProgressIndicator()),
        ),
        const SizedBox(
          height: 12,
        ),
        Text(
          name,
          style: const TextStyle(
              fontSize: 24.0,
              color: MoodleColors.black,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
