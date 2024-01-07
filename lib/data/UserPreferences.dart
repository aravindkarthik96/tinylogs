import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const _onboardingCompleteKey = 'onboardingComplete';

  // Call this method when the onboarding is completed
  static Future<void> setOnboardingComplete() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompleteKey, true);
  }

  // Call this method to check if onboarding is completed
  static Future<bool> isOnboardingComplete() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompleteKey) ?? false;
  }
}
