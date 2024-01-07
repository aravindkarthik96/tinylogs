import 'package:flutter/material.dart';
import 'package:tnylogs/screens/TinyLogsAddLogPage.dart';

class TinyLogsOnboardingPage extends StatefulWidget {
  const TinyLogsOnboardingPage({super.key});

  @override
  State<TinyLogsOnboardingPage> createState() => _TinyLogsOnboardingPageState();
}

class _TinyLogsOnboardingPageState extends State<TinyLogsOnboardingPage> {
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
            Padding(
              // Padding widget for left and right padding
              padding: const EdgeInsets.fromLTRB(28, 84, 28, 0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TinyLogsAddLogPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFFFF6040),
                  // Text Color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Border radius
                  ),
                  minimumSize: const Size(double.infinity, 56),
                  // Vertical padding if necessary
                  textStyle: const TextStyle(
                    fontSize: 17, // Font size
                    fontWeight: FontWeight.bold, // Font weight
                    letterSpacing: -0.408, // Letter spacing
                  ),
                ),
                child: const Text("Start Writing"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
