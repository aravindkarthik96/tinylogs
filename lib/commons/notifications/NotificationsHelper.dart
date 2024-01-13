import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import "package:timezone/timezone.dart" as tz;
import 'package:tinylogs/data/notifications/NotificationsPreferences.dart';

class NotificationsHelper {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotificationsHelper()
      : flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin() {
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    const androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOSInitializationSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestCriticalPermission: true,
    );
    const initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleDailyNotification(
    DateTime time,
    String title,
    String body,
  ) async {
    cancelAllNotifications();

    final scheduledTime = tz.TZDateTime.now(tz.local).add(
      Duration(
        hours: time.hour - tz.TZDateTime.now(tz.local).hour,
        minutes: time.minute - tz.TZDateTime.now(tz.local).minute,
      ),
    );

    const androidDetails = AndroidNotificationDetails(
      'daily_notification_channel_id',
      'Daily Notifications',
      channelDescription: 'Daily Notification Channel',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iOSDetails = DarwinNotificationDetails(
        presentSound: true,
        presentBadge: true,
        presentBanner: true,
        presentAlert: true,
        interruptionLevel: InterruptionLevel.timeSensitive);
    const platformDetails =
        NotificationDetails(android: androidDetails, iOS: iOSDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      Random(031).nextInt(100000000),
      title,
      body,
      scheduledTime,
      platformDetails,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );

    var notificationMessage =
        "Notification scheduled at ${time.hour}:${time.minute} every day";

    await _testNotifications(notificationMessage);
    await NotificationsPreferences.setNotificationConfigured(true);
    await NotificationsPreferences.setDailyNotificationTime(time);
    return;
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    NotificationsPreferences.setNotificationConfigured(false);
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> _testNotifications(String notificationMessage) async {
    await flutterLocalNotificationsPlugin.show(
      Random(031).nextInt(100000000),
      'tinylogs',
      notificationMessage,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_notification_channel_id_registration_success',
          'Daily Notifications',
          channelDescription: 'Daily Notification Channel',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
            presentSound: true,
            presentBadge: true,
            presentBanner: true,
            presentAlert: true,
            interruptionLevel: InterruptionLevel.critical),
      ),
    );
  }
}
