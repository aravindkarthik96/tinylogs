import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:tinylogs/commons/notifications/NotificationPopup.dart';
import 'package:tinylogs/commons/resources/TinyLogsStyles.dart';
import 'package:tinylogs/commons/widgets/ButtonWidgets.dart';
import 'package:tinylogs/data/crash_reporting/CrashReportingPreferences.dart';
import 'package:tinylogs/data/notifications/NotificationsPreferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../commons/resources/TinyLogsColors.dart';
import '../commons/widgets/Spacers.dart';
import '../commons/widgets/TextWidgets.dart';
import '../firebase_options.dart';
import '../generated/assets.dart';
import 'package:package_info/package_info.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool remindersEnabled = false;
  bool crashReportsEnabled = true;
  DateTime? remindersTime;
  String _appVersion = '';

  @override
  initState() {
    _updateAppVersion();
    _refreshRemindersState();
    _refreshCrashReportingState();
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

  Future<void> _refreshCrashReportingState() async {
    bool newState =
        await CrashReportingPreferences.getCrashReportingEnabledState();
    setState(() {
      crashReportsEnabled = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TinyLogsColors.orangePageBackground,
      appBar: getAppBar("Settings"),
      body: ListView(
        children: <Widget>[
          // getSettingsItem('Change color', () {},
          //     trailingWidget: const Icon(
          //       Icons.circle,
          //       color: TinyLogsColors.orangeLight,
          //       size: 32,
          //     )),
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
          getSettingsSwitchItem(
            "Automatically share crash reports",
            crashReportsEnabled,
            (buttonState) async {
              CrashReportingPreferences.setCrashReportingEnabledState(
                  buttonState);
              if (crashReportsEnabled) {
                FirebaseCrashlytics.instance
                    .setCrashlyticsCollectionEnabled(false);
              } else {
                await Firebase.initializeApp(
                  options: DefaultFirebaseOptions.currentPlatform,
                );
              }
              setState(() {
                _refreshCrashReportingState();
              });
            },
          ),
          getSettingsItem('Backup and restore', () {},
              trailingWidget:
                  TextWidgets.getSentenceRegularText("Coming soon")),
          getSettingsItem('Privacy Disclaimer', () {},
              trailingWidget:
                  TextWidgets.getSentenceRegularText("Coming soon")),
          getSettingsSectionTitle('SUPPORT US'),
          // getSettingsItem(
          //   'Buy us a coffee',
          //       () {
          //     _openBuyMeCoffee();
          //   },
          //   trailingWidget: Image.asset(Assets.imagesIconBuyMeCoffee, width: 24, height: 24,),
          // ),
          getSettingsItem(
            'Follow us on Instagram',
            () {
              _openInstagramPage();
            },
            trailingWidget: Image.asset(
              Assets.imagesIconInstagram,
              width: 24,
              height: 24,
            ),
          ),
          getSettingsItem(
            'Give us feedback',
            () {
              _sendEmail();
            },
            trailingWidget: Image.asset(
              Assets.imagesIconChevronRight,
              width: 24,
              height: 24,
            ),
          ),
          Spacers.thirtyTwoPx,
          getSettingsItem(
            "App version",
            () {},
            trailingWidget: TextWidgets.getSentenceRegularText(_appVersion),
          )
        ],
      ),
    );
  }

  void _sendEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'parijatshekher@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Hey! Sharing my feedback on the Tinylogs app'
      }),
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
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

  Future<void> _updateAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  Future<void> _openBuyMeCoffee() async {
    const url = 'https://www.buymeacoffee.com/parijatshec';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  Future<void> _openInstagramPage() async {
    const url = 'https://www.instagram.com/tinylogsapp/';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}
