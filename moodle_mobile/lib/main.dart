import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/constants/dimens.dart';
import 'package:moodle_mobile/data/bg_service/bg_service.dart';
import 'package:moodle_mobile/data/firebase/firebase_helper.dart';
import 'package:moodle_mobile/di/service_locator.dart';
import 'package:moodle_mobile/provider/LocaleManager.dart';
import 'package:moodle_mobile/view/splash/splash_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'constants/colors.dart';
import 'data/firebase/firebase_helper.dart';
import 'data/bg_service/bg_service.dart';
import 'data/notifications/notification_helper.dart';
import 'di/service_locator.dart';
import 'view/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  await initDownloader();
  await FirebaseHelper.initFirebase();
  await BgService.initBackgroundService();
  await NotificationHelper.initNotificationService();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LocaleNotifier>(
          create: (_) => LocaleNotifier(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> initDownloader() async {
  try {
    await FlutterDownloader.initialize(debug: kDebugMode);
  } catch (e) {
    if (kDebugMode) {
      print('!!!!!!!!!!$e');
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  void _bindBackgroundIsolate() {
    ReceivePort _port = ReceivePort();

    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    try {
      _bindBackgroundIsolate();
      FlutterDownloader.registerCallback(downloadCallback);
    } catch (e) {
      if (kDebugMode) {
        print('!!!!!!!!!!$e');
      }
    }

    return Consumer<LocaleNotifier>(
      builder: (context, locale, _) => MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        useInheritedMediaQuery: true,
        locale: locale.getLocale(),
        title: 'Moodle App',
        theme: ThemeData(
          fontFamily: 'SF',
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: MoodleColors.blue,
            onPrimary: Colors.black,
            secondary: MoodleColors.blue,
            onSecondary: Colors.black,
            background: Colors.white,
            onBackground: Colors.black,
            // Need to consider again
            primaryVariant: Colors.black,
            secondaryVariant: Colors.black,
            surface: Colors.white,
            onSurface: Colors.black,
            error: CupertinoColors.systemRed,
            onError: Colors.white,
          ),
          cardTheme: CardTheme(
            color: Theme.of(context).colorScheme.surface,
            elevation: 8,
            shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(Dimens.default_card_radius)),
            ),
          ),
          appBarTheme: Theme.of(context).appBarTheme.copyWith(
                foregroundColor: Colors.white,
                actionsIconTheme: Theme.of(context).iconTheme.copyWith(
                      size: 60,
                      color: MoodleColors.white,
                    ),
              ),
          bottomNavigationBarTheme: Theme.of(context)
              .bottomNavigationBarTheme
              .copyWith(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  unselectedItemColor: Theme.of(context).colorScheme.onSurface),
          bottomSheetTheme: const BottomSheetThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimens.default_sheet_radius),
                topRight: Radius.circular(Dimens.default_sheet_radius),
              ),
            ),
          ),
        ),
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
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