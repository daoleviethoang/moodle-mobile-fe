import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/dimens.dart';

class CustomButtonWidget extends StatelessWidget {
  final String textButton;
  final VoidCallback? onPressed;

  const CustomButtonWidget({Key? key, required this.textButton, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        textButton,
        style: const TextStyle(fontSize: 16),
      ),
      style: ButtonStyle(
        backgroundColor: onPressed == null
            ? MaterialStateProperty.all(Colors.black54)
            : MaterialStateProperty.all(MoodleColors.blue),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        minimumSize: MaterialStateProperty.all(const Size.fromHeight(50.0)),
        shape: MaterialStateProperty.all(const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(Dimens.default_border_radius)))),
      ),
    );
  }
}
