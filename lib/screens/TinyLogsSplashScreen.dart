import 'package:flutter/material.dart';
import 'package:tinylogs/screens/home/TinyLogsHomePage.dart';
import 'package:tinylogs/screens/TinyLogsOnboardingPage.dart';

import '../data/onboarding/OnboardingPreferences.dart';

class TinyLogsSplashScreen extends StatefulWidget {
  const TinyLogsSplashScreen({super.key});

  @override
  State<TinyLogsSplashScreen> createState() => _TinyLogsSplashScreenState();
}

class _TinyLogsSplashScreenState extends State<TinyLogsSplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/images/logo.png",
          width: 180,
          height: 44,
        ),
      ),
    );
  }

  _navigateToNextScreen() async {
    // Assuming you have the UserPreferences class as previously described
    bool onboardingComplete = await OnboardingPreferences.isOnboardingComplete();

    // Wait for 2 seconds to simulate a splash screen delay
    await Future.delayed(const Duration(seconds: 2));

    var page = mounted && onboardingComplete
        ? const TinyLogsHomePage()
        : const TinyLogsOnboardingPage();

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return page;
    }));
  }
}
