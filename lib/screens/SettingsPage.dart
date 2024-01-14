import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tinylogs/commons/notifications/NotificationPopup.dart';
import 'package:tinylogs/commons/resources/TinyLogsStyles.dart';
import 'package:tinylogs/commons/widgets/ButtonWidgets.dart';
import 'package:tinylogs/data/notifications/NotificationsPreferences.dart';

import '../commons/resources/TinyLogsColors.dart';
import '../commons/widgets/TextWidgets.dart';
import '../generated/assets.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool remindersEnabled = false;
  DateTime? remindersTime;

  @override
  initState() {
    _refreshRemindersState();
    super.initState();
  }

  Future<void> _refreshRemindersState() async {
    bool newState = await NotificationsPreferences.getNotificationConfigured();
    DateTime? newReminderTime =
        await NotificationsPreferences.getDailyNotificationTime();
    setState(() {
      remindersEnabled = newState;
      remindersTime = newReminderTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TinyLogsColors.orangePageBackground,
      appBar: getAppBar("Settings"),
      body: ListView(
        children: <Widget>[
          getSettingsItem('Change color', () {},
              trailingWidget: const Icon(
                Icons.circle,
                color: TinyLogsColors.orangeLight,
                size: 32,
              )),
          getSettingsSectionTitle("DAILY REMINDERS"),
          getSettingsSwitchItem(
            "Reminders enabled",
            remindersEnabled,
            (buttonState) async {
              if (!remindersEnabled) {
                await showNotificationPopup(context);
              } else {
                NotificationsPreferences.setNotificationConfigured(false);
              }
              setState(() {
                _refreshRemindersState();
              });
            },
          ),
          getReminderTime(),
          getSettingsSectionTitle('YOUR DATA'),
          getSettingsItem('Backup and restore', () {},
              trailingWidget:
                  TextWidgets.getSentenceRegularText("Coming soon")),
          getSettingsItem('Privacy Disclaimer', () {},
              trailingWidget:
                  TextWidgets.getSentenceRegularText("Coming soon")),
          getSettingsSectionTitle('SUPPORT US'),
          getSettingsItem(
            'Buy us a coffee',
            () {},
            trailingWidget: const Icon(Icons.coffee),
          ),
          getSettingsItem(
            'Follow us on Instagram',
            () {},
            trailingWidget: const Icon(Icons.camera_alt),
          ),
          getSettingsItem(
            'Give us feedback',
            () {},
            trailingWidget: const Icon(Icons.mail),
          ),
        ],
      ),
    );
  }

  Widget getReminderTime() {
    return remindersEnabled && remindersTime != null
        ? getSettingsItem('Reminder time', () async {
            await showNotificationPopup(context);
          },
            trailingWidget: TextWidgets.getSentenceRegularText(
                "${remindersTime!.hour}:${remindersTime!.minute}"))
        : const SizedBox.shrink();
  }

  Padding getSettingsSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(title, style: TinyLogsStyles.tinyTitleStyle),
    );
  }

  AppBar getAppBar(String text) {
    return AppBar(
      leading: ButtonWidgets.getSmallIconButton(Assets.imagesArrowLeft, () {
        Navigator.of(context).pop();
      }),
      title: Text(text,
          style: const TextStyle(
            fontSize: 17.0,
            color: TinyLogsColors.orangeDark,
            fontWeight: FontWeight.w700,
            height: 1.4,
          )),
      backgroundColor: TinyLogsColors.orangePageBackground,
    );
  }

  SwitchListTile getSettingsSwitchItem(
    String text,
    bool state,
    void Function(bool switchState) onTap,
  ) {
    return SwitchListTile(
      title: Text(text),
      value: state,
      onChanged: onTap,
      tileColor: TinyLogsColors.white,
      activeColor: TinyLogsColors.orangeRegular,
    );
  }

  ListTile getSettingsItem(String text, void Function() onTap,
      {Widget? trailingWidget}) {
    return ListTile(
      title: Text(text),
      trailing: trailingWidget,
      onTap: onTap,
      tileColor: TinyLogsColors.white,
    );
  }
}
