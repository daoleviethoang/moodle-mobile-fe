import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/screens/login.dart';

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
      )),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
