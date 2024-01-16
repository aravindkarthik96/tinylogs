import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinylogs/commons/notifications/NotificationsHelper.dart';

class CrashReportingPreferences {
  static const _isCrashReportingEnabled = 'isCrashReportingEnabled';

  static Future<void> setCrashReportingEnabledState(bool state) async {
    if (!state) {
      NotificationsHelper().cancelAllNotifications();
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isCrashReportingEnabled, state);
  }

  static Future<bool> getCrashReportingEnabledState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isCrashReportingEnabled) ?? true;
  }

}
