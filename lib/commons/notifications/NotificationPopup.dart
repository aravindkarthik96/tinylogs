import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tinylogs/commons/notifications/NotificationsHelper.dart';
import 'package:tinylogs/commons/widgets/Spacers.dart';
import 'package:tinylogs/commons/widgets/TextWidgets.dart';

import '../resources/TinyLogsStrings.dart';
import '../widgets/ButtonWidgets.dart';

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
                  TextWidgets.getDialogueTitleText(
                      NotificationsDialogueStrings.notificationDialogueTitle),
                  Spacers.sixteenPx,
                  TextWidgets.getNotificationsDescriptionText(
                      NotificationsDialogueStrings
                          .notificationDialogueDescription),
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
                  Spacers.sixteenPx,
                  ButtonWidgets.getPrimaryButton(
                    NotificationsDialogueStrings.confirmButtonText,
                    () {
                      NotificationsHelper().scheduleDailyNotification(
                        TimeOfDay.fromDateTime(selectedTime),
                        NotificationsDialogueStrings.notificationMessageTitle,
                        NotificationsDialogueStrings.notificationMessageDescription,
                      );
                      Navigator.pop(context);
                    },
                  ),
                  Spacers.twentyPx,
                  ButtonWidgets.getLargeNakedButton(NotificationsDialogueStrings.dismissButtonText,() {
                    Navigator.pop(context);
                  }),
                  Spacers.thirtyTwoPx,
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}
