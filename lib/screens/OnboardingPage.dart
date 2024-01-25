import 'package:flutter/material.dart';
import 'package:tinylogs/commons/resources/TinyLogsStrings.dart';
import 'package:tinylogs/commons/widgets/ButtonWidgets.dart';
import 'package:tinylogs/commons/widgets/TextWidgets.dart';
import 'package:tinylogs/generated/assets.dart';
import 'package:tinylogs/screens/AddLogPage.dart';

import '../commons/widgets/Spacers.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
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
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              28,
              0,
              28,
              48,
            ),
            child: ButtonWidgets.getPrimaryButton(
              OnboardingPageString.onboardingCTAText,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddLogPage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
