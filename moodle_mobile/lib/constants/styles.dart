import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class MoodleStyles {

  MoodleStyles._();

  static const TextStyle courseHeaderStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static Map<String, Style> htmlStyle = {
    'h1': Style(fontSize: const FontSize(19)),
    'h2': Style(fontSize: const FontSize(17.5)),
    'h3': Style(fontSize: const FontSize(16)),
  };
}