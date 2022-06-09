import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/dimens.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final String hintText;
  final bool hidePass;
  final TextEditingController controller;
  final int? maxLines;
  final double borderRadius;
  final IconData? prefixIcon; // ? accept null value

  const CustomTextFieldWidget(
      {Key? key,
      required this.hintText,
      this.hidePass = false,
      this.prefixIcon,
      this.maxLines = 1,
      required this.controller,
      required this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: hidePass,
      maxLines: maxLines,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(Dimens.default_padding_double),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        hintText: hintText,
        labelText: hintText,
        isDense: true,
        hintStyle: const TextStyle(fontSize: 16),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
      ),
    );
  }
}
