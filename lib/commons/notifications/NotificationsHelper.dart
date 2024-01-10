import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import "package:timezone/timezone.dart" as tz;

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
      TimeOfDay time, String title, String body) async {
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

    const iOSDetails = DarwinNotificationDetails();
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
      androidAllowWhileIdle: true,
    );

    var notificationMessage = "Notification scheduled at ${time.hour}:${time.minute} every day";
    print(notificationMessage);
    await _testNotifications(
        notificationMessage);
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
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
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          subtitle: "test",

        ),
      ),
    );
  }
}
