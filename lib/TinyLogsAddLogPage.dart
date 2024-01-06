import 'package:flutter/material.dart';

class TinyLogsAddLogPage extends StatefulWidget {
  const TinyLogsAddLogPage({super.key});

  @override
  State<TinyLogsAddLogPage> createState() => _TinyLogsAddLogPageState();
}

class _TinyLogsAddLogPageState extends State<TinyLogsAddLogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 17, // Text size
                  letterSpacing: -0.02, // Letter spacing
                  color: Color(0xFF564DBF), // Text color
                  height: 24 /
                      17, // Line height divided by font size for line height ratio
                ),
                children: <TextSpan>[
                  TextSpan(text: 'Write about things '),
                  TextSpan(
                    text: '\nwhich make you happy!',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
