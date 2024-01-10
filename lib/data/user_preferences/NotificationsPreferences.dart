import 'package:shared_preferences/shared_preferences.dart';

class NotificationsPreferences {
  static const _notificationSetKey = 'isNotificationsConfigured';
  static const _notificationDialogueDismissed =
      'isNotificationDialogueDismissed';
  static const _notificationDialogueDismissedDate =
      'notificationDialogueDismissedDate';
  static const _dailyNotificationTime = 'dailyNotificationTime';

  static Future<void> setNotificationConfigured() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationSetKey, true);
  }

  static Future<bool> getNotificationConfigured() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationSetKey) ?? false;
  }

  static Future<void> setNotificationDialogueDismissed() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationDialogueDismissed, true);
  }

  static Future<bool> getNotificationDialogueDismissed() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationDialogueDismissed) ?? false;
  }

  static Future<void> setNotificationDialogueDismissedDate(
      DateTime time) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_notificationDialogueDismissedDate, time as String);
  }

  static Future<DateTime?> getNotificationDialogueDismissedDate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var dateTimeString = prefs.getString(_notificationDialogueDismissedDate);

    if (dateTimeString != null) {
      return DateTime.tryParse(dateTimeString);
    } else {
      return null;
    }
  }

  static Future<void> setDailyNotificationTime(DateTime time) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_dailyNotificationTime, time as String);
  }

  static Future<DateTime?> getDailyNotificationTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var dateTimeString = prefs.getString(_dailyNotificationTime);

    if (dateTimeString != null) {
      return DateTime.tryParse(dateTimeString);
    } else {
      return null;
    }
  }
}
