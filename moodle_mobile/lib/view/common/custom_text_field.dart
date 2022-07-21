import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
  final bool readonly;
  final Color? fillColor;
  final double elevation;
  final Function()? onTap;

  const CustomTextFieldWidget(
      {Key? key,
      required this.hintText,
      this.hidePass = false,
      this.prefixIcon,
      this.maxLines = 1,
      this.fontSize = 16,
      this.haveLabel = true,
      this.readonly = false,
      this.fillColor,
      this.elevation = 0,
      this.onTap,
      required this.controller,
      required this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      child: TextField(
        //keyboardType: TextInputType.visiblePassword,
        readOnly: readonly,
        controller: controller,
        obscureText: hidePass,
        maxLines: maxLines,
        onTap: onTap,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(Dimens.default_padding_double),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          hintText: hintText,
          labelText: haveLabel ? hintText : null,
          isDense: true,
          hintStyle: TextStyle(
            fontSize: fontSize,
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
          filled: fillColor != null,
          fillColor: fillColor,
        ),
      ),
    );
  }
}

class NoteAddTextField extends StatelessWidget {
  final Function()? onTap;

  const NoteAddTextField({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextFieldWidget(
      controller:
          TextEditingController(text: AppLocalizations.of(context)!.add_note),
      hintText: AppLocalizations.of(context)!.add_note,
      haveLabel: false,
      borderRadius: Dimens.default_border_radius,
      readonly: true,
      fillColor: Colors.white,
      prefixIcon: Icons.note_add_rounded,
      elevation: 2,
      onTap: onTap,
    );
  }
}
