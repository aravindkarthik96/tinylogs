import 'package:flutter/material.dart';
import 'package:tinylogs/screens/TinyLogsOnboardingPage.dart';


void main() {
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
