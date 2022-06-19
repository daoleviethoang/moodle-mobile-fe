import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/dimens.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final String hintText;
  final bool hidePass;
  final TextEditingController controller;
  final int? maxLines;
  final double borderRadius;
  final IconData? prefixIcon; // ? accept null value
  final bool haveLabel;
  final double fontSize;

  const CustomTextFieldWidget(
      {Key? key,
      required this.hintText,
      this.hidePass = false,
      this.prefixIcon,
      this.maxLines = 1,
      this.fontSize = 16,
      this.haveLabel = true,
      required this.controller,
      required this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.visiblePassword,
      controller: controller,
      obscureText: hidePass,
      maxLines: maxLines,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(Dimens.default_padding_double),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        hintText: hintText,
        labelText: haveLabel ? hintText : null,
        isDense: true,
        hintStyle: TextStyle(
          fontSize: fontSize,
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
      ),
    );
  }
}
