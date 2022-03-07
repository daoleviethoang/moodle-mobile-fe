import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/dimens.dart';

class CustomButtonShort extends StatelessWidget {
  const CustomButtonShort({
    Key? key,
    required this.text,
    required this.textColor,
    required this.bgColor,
    required this.blurRadius,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final Color textColor;
  final Color bgColor;
  final double blurRadius;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
              Radius.circular(Dimens.default_border_radius)),
          boxShadow: [
            BoxShadow(
              color: MoodleColors.darkGrayShadow,
              blurRadius: blurRadius,
            )
          ]),
      width: MediaQuery.of(context).size.width / 2.3,
      height: 48,
      child: TextButton(
        onPressed: () {},
        child: Text(text,
            style: TextStyle(color: textColor, fontWeight: FontWeight.w700)),
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(bgColor)),
      ),
    );
  }
}
