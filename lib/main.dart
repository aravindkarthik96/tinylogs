// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

void main() {
  runApp(const TinyLogsApp());
}

class TinyLogsApp extends StatelessWidget {
  const TinyLogsApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TinyLogsHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class TinyLogsHomePage extends StatefulWidget {
  const TinyLogsHomePage({super.key, required this.title});

  final String title;

  @override
  State<TinyLogsHomePage> createState() => _TinyLogsHomePageState();
}

class _TinyLogsHomePageState extends State<TinyLogsHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/images/logo.png",
              width: 180,
              height: 44,
            ),
            const SizedBox(height: 110),
            Image.asset("assets/images/onboarding_illustration.png",
                width: 271, height: 245),
            const SizedBox(height: 54),
            Image.asset("assets/images/message_header_icon.png",
                width: 28, height: 18),
            const SizedBox(height: 10),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 17, // Text size
                  letterSpacing: -0.02, // Letter spacing
                  color: Color(0xFF564DBF), // Text color
                  height: 24 /
                      17, // Line height divided by font size for line height ratio
                ),
                children: const <TextSpan>[
                  TextSpan(text: 'Write about things '),
                  TextSpan(
                    text: '\nwhich make you happy!',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              // Padding widget for left and right padding
              padding: EdgeInsets.fromLTRB(28, 84, 28, 0),
              child: ElevatedButton(
                onPressed: () {
                  // Define the action when the button is pressed
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFFFF6040),
                  // Text Color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Border radius
                  ),
                  minimumSize: Size(double.infinity, 56),
                  // Width and Height
                  padding: EdgeInsets.symmetric(vertical: 0.0),
                  // Vertical padding if necessary
                  textStyle: TextStyle(
                    fontSize: 17, // Font size
                    fontWeight: FontWeight.bold, // Font weight
                    letterSpacing: -0.408, // Letter spacing
                  ),
                ),
                child: Text("Start Writing"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
