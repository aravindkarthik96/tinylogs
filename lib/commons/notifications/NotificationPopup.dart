import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tinylogs/commons/notifications/NotificationsHelper.dart';
import 'package:tinylogs/commons/widgets/Spacers.dart';
import 'package:tinylogs/commons/widgets/TextWidgets.dart';

import '../resources/TinyLogsStrings.dart';
import '../widgets/ButtonWidgets.dart';

Future<void> showNotificationPopup(BuildContext context) async {
  DateTime selectedTime = DateTime.now();
  await showModalBottomSheet(
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
                    () async {
                      await NotificationsHelper().scheduleDailyNotification(
                        selectedTime,
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
