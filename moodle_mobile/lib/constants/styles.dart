import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'colors.dart';

class MoodleStyles {
  MoodleStyles._();

  static const TextStyle appBarTitleStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
      letterSpacing: 1,
      color: MoodleColors.white);

  static const courseFilterHeaderStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    letterSpacing: 0.27,
    color: MoodleColors.black,
  );

  static const courseFilterButtonTextStyle = TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 16);

  static const sectionHeaderStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );

  static const TextStyle courseHeaderStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static Map<String, Style> htmlStyle = {
    'h1': Style(fontSize: const FontSize(19)),
    'h2': Style(fontSize: const FontSize(17.5)),
    'h3': Style(fontSize: const FontSize(16)),
  };

  static const TextStyle messageContentStyle =
      TextStyle(fontSize: 12, color: MoodleColors.gray);

  static Style rightMessageTextStyle = Style(color: MoodleColors.white);

  static const TextStyle notificationTimestampStyle = TextStyle(fontSize: 12);
}