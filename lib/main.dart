import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:tinylogs/commons/notifications/NotificationsHelper.dart';
import 'package:tinylogs/screens/OnboardingPage.dart';
import 'package:tinylogs/screens/home/HomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'data/onboarding/OnboardingPreferences.dart';

bool onboardingCompleted = false;

Future<void> main() async {
  if (!Platform.isAndroid && !Platform.isIOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  _configureLocalTimeZone();
  NotificationsHelper();
  bool onboardingStatus = await OnboardingPreferences.isOnboardingComplete();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(TinyLogsApp(onboardingStatus));
}

Future<void> _configureLocalTimeZone() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

class TinyLogsApp extends StatelessWidget {
  final bool _onboardingStatus;

  const TinyLogsApp(this._onboardingStatus, {super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseCrashlytics.instance.crash();
    return MaterialApp(
      title: 'TinyLogs',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: _onboardingStatus ? const HomePage() : const OnboardingPage(),
    );
  }
}
