import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tinylogs/data/logs_data/DatabaseHelper.dart';

import '../../../data/logs_data/LogEntry.dart';

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
  String longestStreakDescription = "";
  String currentStreakDescription = "";

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
        wordCount = getTotalWordCount(updatedLogs);
        timeSinceFirstLog =
            DateTime.now().difference(updatedLogs.first.creationDate).inDays;
        longestStreak = getLongestStreak(uniqueLogDates);
        currentStreak = getCurrentStreak(uniqueLogDates);
      },
    );
  }

  int getTotalWordCount(List<LogEntry> logs) {
    int totalWords = 0;

    for (var log in logs) {
      List<String> words = log.content.split(RegExp(r'\s+'));

      words = words.where((word) => word.isNotEmpty).toList();

      totalWords += words.length;
    }

    return totalWords;
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
        currentDate = currentDate.subtract(Duration(days: 1));
      } else {
        break;
      }
    }

    return currentStreak;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Text(
            "Insights",
            style: TextStyle(
              fontFamily: "SF Pro Display",
              fontWeight: FontWeight.w700,
              fontSize: 34,
              color: Color(0xFFFF6040),
            ),
          ),
        ),
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
                const Text(
                  "Tiny wins",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontFamily: "SF Pro Display",
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                      color: Color(0xFF662619)),
                ),
                const SizedBox(
                  height: 16,
                ),
                addInsight(
                  "assets/images/icon_thumbs_up.png",
                  "You have written a total of",
                  "$logCount logs and $wordCount words",
                  "",
                ),
                const SizedBox(
                  height: 16,
                ),
                addInsight(
                  "assets/images/icon_cloud_with_sun_and_rain.png",
                  "You have been using the app for",
                  "$timeSinceFirstLog days",
                  "",
                ),
                const SizedBox(
                  height: 16,
                ),
                addInsight(
                  "assets/images/icon_medal.png",
                  "Your current streak is",
                  "${currentStreak.length} days",
                  " ${getStreakDescription(currentStreak)}",
                ),
                const SizedBox(
                  height: 16,
                ),
                addInsight(
                  "assets/images/icon_medal_dark.png",
                  "Your longest streak is",
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

  Row addInsight(
    String icon,
    String title,
    String subtitle,
    String description,
  ) {
    return Row(
      children: [
        Image.asset(
          icon,
          width: 36,
          height: 36,
        ),
        const SizedBox(
          width: 16,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontFamily: "SF Pro Display",
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    height: 1.3,
                    color: Color(0xFF292929))),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: subtitle,
                    style: const TextStyle(
                        fontFamily: "SF Pro Display",
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                        color: Color(0xFFFF6040)),
                  ),
                  TextSpan(
                    text: description,
                    style: const TextStyle(
                      fontFamily: "SF Pro Text",
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 15.0,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  String getStreakDescription(List<DateTime> longestStreak) {
    if (longestStreak.isEmpty) {
      return "";
    }

    var dateFormat = DateFormat("d MMM");
    return "from ${dateFormat.format(longestStreak.first)} - ${dateFormat.format(longestStreak.last)}";
  }
}
