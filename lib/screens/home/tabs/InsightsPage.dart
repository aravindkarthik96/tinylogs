import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tinylogs/commons/resources/TinyLogsStrings.dart';
import 'package:tinylogs/commons/widgets/ButtonWidgets.dart';
import 'package:tinylogs/commons/widgets/TextWidgets.dart';
import 'package:tinylogs/data/logs_data/DatabaseHelper.dart';
import 'package:tinylogs/screens/SettingsPage.dart';

import '../../../commons/utils/TextUtils.dart';
import '../../../commons/widgets/Containers.dart';
import '../../../data/logs_data/LogEntry.dart';
import '../../../generated/assets.dart';
import '../../../commons/widgets/Spacers.dart';

class InsightsPage extends StatefulWidget {
  const InsightsPage({super.key});

  @override
  _InsightsPageState createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  List<LogEntry> logs = [];

  int logCount = 0;
  int timeSinceFirstLog = 0;
  int wordCount = 0;
  List<DateTime> longestStreak = [];
  List<DateTime> currentStreak = [];

  @override
  void initState() {
    super.initState();
    loadInsights();
  }

  Future<void> loadInsights() async {
    List<LogEntry> updatedLogs = await DatabaseHelper.instance.queryAllLogs();
    List<DateTime> uniqueLogDates =
        await DatabaseHelper.instance.fetchUniqueLogDates();
    setState(
      () {
        logCount = updatedLogs.length;
        wordCount = TextUtils.getTotalWordCount(updatedLogs);
        timeSinceFirstLog =
            DateTime.now().difference(updatedLogs.last.creationDate).inDays;
        longestStreak = getLongestStreak(uniqueLogDates);
        currentStreak = getCurrentStreak(uniqueLogDates);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: TextWidgets.getPageTitleText(
            InsightsPageStrings.insightsPageTitle,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 28),
            child: ButtonWidgets.getMediumIconButton(
              Assets.imagesIconSettings,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                );
              },
            ),
          )
        ],
        backgroundColor: Colors.white,
        centerTitle: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 12, 32, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidgets.getSectionTitle(
                  InsightsPageStrings.insightsSectionTitle,
                ),
                Spacers.sixteenPx,
                Containers.getInsightRow(
                  Assets.imagesIconThumbsUp,
                  InsightsPageStrings.insightsTotalLogsTitle,
                  "$logCount logs and $wordCount words",
                  "",
                ),
                Spacers.sixteenPx,
                Containers.getInsightRow(
                  Assets.imagesIconCloudWithSunAndRain,
                  InsightsPageStrings.insightsTotalUsageDaysTitle,
                  "$timeSinceFirstLog days",
                  "",
                ),
                Spacers.sixteenPx,
                Containers.getInsightRow(
                  Assets.imagesIconMedal,
                  InsightsPageStrings.currentStreakTitle,
                  "${currentStreak.length} days",
                  " ${getStreakDescription(currentStreak)}",
                ),
                Spacers.sixteenPx,
                Containers.getInsightRow(
                  Assets.imagesIconMedalDark,
                  InsightsPageStrings.longestStreakTitle,
                  "${longestStreak.length} days",
                  " ${getStreakDescription(longestStreak)}",
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: const Color(0xFFF1F1F1),
            ),
          )
        ],
      ),
    );
  }

  String getStreakDescription(List<DateTime> longestStreak) {
    if (longestStreak.isEmpty) {
      return "";
    }

    var dateFormat = DateFormat("d MMM");
    return "from ${dateFormat.format(longestStreak.first)} - ${dateFormat.format(longestStreak.last)}";
  }

  List<DateTime> getLongestStreak(List<DateTime> uniqueLogDates) {
    uniqueLogDates.sort((a, b) => a.compareTo(b));

    List<DateTime> longestStreak = [];
    List<DateTime> currentStreak = [];

    for (int i = 0; i < uniqueLogDates.length; i++) {
      if (i == 0 ||
          uniqueLogDates[i].difference(uniqueLogDates[i - 1]).inDays == 1) {
        currentStreak.add(uniqueLogDates[i]);
      } else {
        if (currentStreak.length > longestStreak.length) {
          longestStreak = List.from(currentStreak);
        }
        currentStreak = [uniqueLogDates[i]];
      }
    }

    if (currentStreak.length > longestStreak.length) {
      longestStreak = currentStreak;
    }

    return longestStreak;
  }

  List<DateTime> getCurrentStreak(List<DateTime> uniqueLogDates) {
    uniqueLogDates.sort((a, b) => b.compareTo(a));

    List<DateTime> currentStreak = [];
    DateTime today = DateTime.now();
    DateTime currentDate = DateTime(today.year, today.month, today.day);

    for (DateTime date in uniqueLogDates) {
      if (date.isAtSameMomentAs(currentDate) ||
          (currentStreak.isNotEmpty &&
              date.difference(currentStreak.last).inDays == -1)) {
        currentStreak.add(date);
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return currentStreak.reversed.toList();
  }
}
