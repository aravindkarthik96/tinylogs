import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPreferences {
  static const _onboardingCompleteKey = 'onboardingComplete';

  static Future<void> setOnboardingComplete() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompleteKey, true);
  }

  static Future<bool> isOnboardingComplete() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompleteKey) ?? false;
  }
}
