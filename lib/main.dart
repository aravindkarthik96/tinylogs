import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tinylogs/screens/TinyLogsOnboardingPage.dart';


void main() {
  // Initialize sqflite for non-mobile platforms
  if (!Platform.isAndroid && !Platform.isIOS) {
    // This line is crucial
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const TinyLogsApp());
}

class TinyLogsApp extends StatelessWidget {
  const TinyLogsApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TinyLogs',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const TinyLogsOnboardingPage(),
    );
  }
}
