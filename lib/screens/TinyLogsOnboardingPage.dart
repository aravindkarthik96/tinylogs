import 'package:flutter/material.dart';
import 'package:tinylogs/commons/resources/TinyLogsColors.dart';
import 'package:tinylogs/commons/resources/TinyLogsStrings.dart';
import 'package:tinylogs/commons/widgets/ButtonWidgets.dart';
import 'package:tinylogs/commons/widgets/TextWidgets.dart';
import 'package:tinylogs/generated/assets.dart';
import 'package:tinylogs/screens/TinyLogsAddLogPage.dart';

import '../commons/widgets/Spacers.dart';

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
              Assets.imagesLogo,
              width: 180,
              height: 44,
            ),
            Spacers.hundredEightPx,
            Image.asset(
              Assets.imagesOnboardingIllustration,
              width: 271,
              height: 245,
            ),
            Spacers.fiftyTwoPx,
            Image.asset(
              Assets.imagesMessageHeaderIcon,
              width: 28,
              height: 18,
            ),
            Spacers.eightPx,
            TextWidgets.getMultiLinePurpleText(
                OnboardingPageString.onboardingMessageLine1,
                OnboardingPageString.onboardingMessageLine2),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                28,
                84,
                28,
                0,
              ),
              child: ButtonWidgets.getPrimaryButton(
                  OnboardingPageString.onboardingCTAText, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TinyLogsAddLogPage()),
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
