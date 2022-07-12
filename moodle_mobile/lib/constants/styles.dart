import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'colors.dart';

class MoodleStyles {
  MoodleStyles._();

  static const TextStyle appBarTitleStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
    letterSpacing: 1,
    color: MoodleColors.white,
  );

  static const bottomSheetTitleStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: MoodleColors.blue,
  );

  static const bottomSheetHeaderStyle = TextStyle(fontSize: 20);

  static const courseFilterHeaderStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    letterSpacing: 0.27,
    color: MoodleColors.black,
  );

  static const courseFilterButtonTextStyle =
      TextStyle(fontWeight: FontWeight.w700, fontSize: 16);

  static const sectionHeaderStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );

  static const TextStyle courseHeaderStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle noteFolderNameStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static TextStyle noteFolderCountStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: MoodleColors.black.withOpacity(.25),
  );

  static const TextStyle noteHeaderStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle noteTimestampStyle =
      TextStyle(fontSize: 12, color: MoodleColors.gray);

  static Map<String, Style> noteTextStyle(bool isDone) {
    final html = htmlStyle;
    html.addAll({
      '*': Style(
        textDecoration:
            isDone ? TextDecoration.lineThrough : TextDecoration.none,
      ),
    });
    return html;
  }

  static const TextStyle noteSeeAllStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: MoodleColors.blue,
    decoration: TextDecoration.none,
  );

  static Map<String, Style> get htmlStyle => {
    'div': Style(textOverflow: TextOverflow.visible),
    'h1': Style(fontSize: const FontSize(19)),
    'h2': Style(fontSize: const FontSize(17.5)),
    'h3': Style(fontSize: const FontSize(16)),
    'a': Style(
      fontSize: FontSize.medium,
      fontWeight: FontWeight.bold,
      color: MoodleColors.blue,
      textDecoration: TextDecoration.none,
    ),
  };

  static const TextStyle messageContentStyle =
      TextStyle(fontSize: 12, color: MoodleColors.gray);

  static Style rightMessageTextStyle = Style(color: MoodleColors.white);

  static const TextStyle notificationTimestampStyle = TextStyle(
      fontSize: 13, fontWeight: FontWeight.bold, color: MoodleColors.blue);
}