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
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    await prefs.setInt(_notificationDialogueDismissedDate, timestamp);
  }

  static Future<bool> getNotificationDialogueDismissed() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var state = prefs.getBool(_notificationDialogueDismissed) ?? false;
    if (state) {
      DateTime? dismissDate = await getNotificationDialogueDismissedDate();
      if (dismissDate != null) {
        var currentDate = DateTime.now();
        var difference = currentDate.difference(dismissDate).inHours;
        return difference < 24;
      }
    }
    return state;
  }

  static Future<DateTime?> getNotificationDialogueDismissedDate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? timestamp = prefs.getInt(_notificationDialogueDismissedDate);
    return timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp)
        : null;
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
