import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/screens/login.dart';
=======
import 'package:moodle_mobile/screens/menu.dart';
>>>>>>> menu-phat

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
<<<<<<< HEAD
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
=======
      //title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MenuScreen(),
>>>>>>> menu-phat
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

<<<<<<< HEAD
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
=======
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: MenuScreen(),
    );
>>>>>>> menu-phat
  }
}