import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/dimens.dart';

class CustomButtonWidget extends StatelessWidget {
  final String textButton;
  final VoidCallback? onPressed;
  final bool filled;
  final bool useWarningColor;

  const CustomButtonWidget({
    Key? key,
    required this.textButton,
    this.onPressed,
    this.filled = true,
    this.useWarningColor = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final normalColor = (onPressed == null)
        ? MaterialStateProperty.all(Colors.black54)
        : MaterialStateProperty.all(MoodleColors.blue);
    final warningColor = (onPressed == null)
        ? MaterialStateProperty.all(Colors.black54)
        : MaterialStateProperty.all(Theme.of(context).errorColor);
    final bg = useWarningColor ? warningColor : normalColor;
    final fg = MaterialStateProperty.all(Colors.white);

    return TextButton(
      onPressed: onPressed,
      child: Text(
        textButton,
        style: const TextStyle(fontSize: 16),
      ),
      style: ButtonStyle(
        backgroundColor: filled ? bg : fg,
        foregroundColor: filled ? fg : bg,
        minimumSize: MaterialStateProperty.all(const Size.fromHeight(50.0)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
                Radius.circular(Dimens.default_border_radius)),
            side: filled
                ? BorderSide.none
                : const BorderSide(color: MoodleColors.blue, width: 2),
          ),
        ),
      ),
    );
  }
}