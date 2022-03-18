import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/dimens.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final String hintText;
  final bool hidePass;

  const CustomTextFieldWidget(
      {Key? key, required this.hintText, this.hidePass = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: hidePass,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 16),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(Dimens.default_border_radius))),
      ),
    );
  }
}
