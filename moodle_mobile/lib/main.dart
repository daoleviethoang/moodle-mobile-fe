import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/view/direct_page.dart';
import 'package:moodle_mobile/view/course_category/index.dart';
import 'package:moodle_mobile/view/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moodle App',
      theme: ThemeData(
        primarySwatch: MaterialColor(
          MoodleColors.blue.value,
          const <int, Color>{
            50: MoodleColors.blueLight,
            100: MoodleColors.blueLight,
            200: MoodleColors.blueLight,
            300: MoodleColors.blue,
            400: MoodleColors.blue,
            500: MoodleColors.blue,
            600: MoodleColors.blue,
            700: MoodleColors.blueDark,
            800: MoodleColors.blueDark,
            900: MoodleColors.blueDark,
          },
        ),
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: MoodleColors.blue,
          secondary: MoodleColors.blue,
          background: Colors.white,
          // Need to consider again
          primaryVariant: Colors.black,
          secondaryVariant: Colors.black,
          surface: Colors.black,
          error: Colors.black,
          onPrimary: Colors.black,
          onSecondary: Colors.black,
          onSurface: Colors.black,
          onBackground: Colors.black,
          onError: Colors.black,
        ),

        /// Theme for all cards in this app
        cardTheme: CardTheme(
          color: Theme.of(context).colorScheme.surface,
          elevation: 8,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),

        appBarTheme: Theme.of(context).appBarTheme.copyWith(
          foregroundColor: Colors.white,
        ),
      ),
      //home: const LoginScreen(),
      home: const DirectScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}