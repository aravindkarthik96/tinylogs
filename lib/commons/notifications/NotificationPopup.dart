import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tinylogs/commons/notifications/NotificationsHelper.dart';

void showNotificationPopup(BuildContext context) {
  DateTime selectedTime = DateTime.now();
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Wrap(
        children: <Widget>[
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Set notifications!',
                    style: TextStyle(
                      fontFamily: "SF Pro Display",
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFFF6040),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Research suggests consistency is key to reap the most benefits.',
                    style: TextStyle(
                      fontFamily: "SF Pro Text",
                      color: Color(0xFF662619),
                      fontWeight: FontWeight.w400,
                      fontSize: 17.0,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      use24hFormat: false,
                      onDateTimeChanged: (DateTime newTime) {
                        selectedTime = newTime;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      NotificationsHelper().scheduleDailyNotification(
                        TimeOfDay.fromDateTime(selectedTime),
                        "tinylogs: Daily Reminder",
                        "Don\'t forget to log your gratitude today!",
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFFFF6040),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(double.infinity, 56),
                      textStyle: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.408,
                      ),
                    ),
                    child: const Text("Confirm"),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.fromLTRB(8, 0, 8, 0)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: const BorderSide(
                            color: Color(0xFF662619), width: 1),
                      )),
                      minimumSize: MaterialStateProperty.all(
                        const Size(double.infinity, 56),
                      ),
                    ),
                    child: const Text(
                      'Later',
                      style: TextStyle(
                        fontFamily: "SF Pro Display",
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF662619),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}
