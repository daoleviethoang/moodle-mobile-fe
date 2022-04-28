import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';

class PublicInfomationCommonView extends StatelessWidget {
  final String imageUrl;
  final String name;

  const PublicInfomationCommonView(
      {Key? key, required this.imageUrl, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 159.0,
          height: 159.0,
          decoration: BoxDecoration(
            color: const Color(0xff7c94b6),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(Radius.circular(90.0)),
            border: Border.all(
              color: MoodleColors.white,
              width: 0.0,
            ),
          ),
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
