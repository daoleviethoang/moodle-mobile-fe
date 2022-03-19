import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/dimens.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final String hintText;
  final bool hidePass;
  final TextEditingController controller;
  final IconData? prefixIcon; // ? accept null value

  const CustomTextFieldWidget(
      {Key? key,
      required this.hintText,
      this.hidePass = false,
      this.prefixIcon,
      required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: hidePass,
      decoration: InputDecoration(
        prefixIcon: Icon(prefixIcon),
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 16),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(Dimens.default_border_radius))),
      ),
    );
  }
}
