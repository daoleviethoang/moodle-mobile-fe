import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/di/service_locator.dart';
import 'package:moodle_mobile/screens/login/login.dart';
import 'package:moodle_mobile/screens/message/message_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();

  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => const MyApp(), // Wrap your app
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
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
      home: const MessageScreen(),
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
