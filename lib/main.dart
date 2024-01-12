import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:tinylogs/screens/TinyLogsOnboardingPage.dart';
import 'package:tinylogs/screens/home/TinyLogsHomePage.dart';

import 'data/onboarding/OnboardingPreferences.dart';

bool onboardingCompleted = false;

Future<void> main() async {
  if (!Platform.isAndroid && !Platform.isIOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  _configureLocalTimeZone();
  bool onboardingStatus = await OnboardingPreferences.isOnboardingComplete();
  runApp(TinyLogsApp(onboardingStatus));
}

Future<void> _configureLocalTimeZone() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(
      tz.getLocation(timeZoneName));
}

class TinyLogsApp extends StatelessWidget {
  final bool _onboardingStatus;

  const TinyLogsApp(this._onboardingStatus, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TinyLogs',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: _onboardingStatus
          ? const TinyLogsHomePage()
          : const TinyLogsOnboardingPage(),
    );
  }
}
