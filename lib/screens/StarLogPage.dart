import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tinylogs/commons/resources/TinyLogsColors.dart';
import 'package:tinylogs/commons/resources/TinyLogsStrings.dart';
import 'package:tinylogs/commons/widgets/ButtonWidgets.dart';
import 'package:tinylogs/commons/widgets/Spacers.dart';
import 'package:tinylogs/commons/widgets/TextWidgets.dart';
import 'package:tinylogs/data/onboarding/OnboardingPreferences.dart';
import 'dart:math';

import '../commons/resources/TinyLogsStyles.dart';
import '../data/logs_data/DatabaseHelper.dart';
import '../data/logs_data/LogEntry.dart';
import '../generated/assets.dart';

class StarLogsPage extends StatefulWidget {
  const StarLogsPage({super.key});

  @override
  StarLogsPageState createState() => StarLogsPageState();
}

class StarLogsPageState extends State<StarLogsPage> {
  final int maxStars = 15;
  final int gridRows = 20;
  final int gridCols = 20;
  List<StarLog> logs = [];

  @override
  void initState() {
    super.initState();
    fetchLogs();
    updateStarLogOnboardingStatus();
  }

  Future<void> fetchLogs() async {
    List<LogEntry> updatedLogs = await DatabaseHelper.instance.queryAllLogs();

    var rng = Random();
    Set<Point> usedPoints = {};

    if (!mounted) return;

    final safePaddingTop = MediaQuery.of(context).padding.top;
    final usableScreenHeight =
        MediaQuery.of(context).size.height - safePaddingTop - 56;

    while (logs.length < min(updatedLogs.length, maxStars)) {
      var position = Point(
        rng.nextInt(gridCols),
        rng.nextInt(gridRows - (56 / usableScreenHeight * gridRows).floor()),
      );

      final adjustedY =
          position.y + (56 / usableScreenHeight * gridRows).floor();

      if (!usedPoints.contains(position)) {
        usedPoints.add(position);
        logs.add(StarLog(
          updatedLogs[logs.length],
          position.x / gridCols,
          (adjustedY / gridRows) *
              (usableScreenHeight / MediaQuery.of(context).size.height),
        ));
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ButtonWidgets.getMiniFloatingActionButton(
              Assets.imagesIconMiniCross,
              () {
                Navigator.of(context).pop();
              },
              buttonColor: TinyLogsColors.white,
            ),
            Spacers.sixteenPx,
            Text(
              StarLogPageStrings.clickStarPromptText,
              textAlign: TextAlign.center,
              style: TinyLogsStyles.starLogPromptStyle,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              TinyLogsColors.skyGradientStart,
              TinyLogsColors.skyGradientEnd
            ],
          ),
        ),
        child: Stack(
          children: logs
              .map((log) => Positioned(
                    left: MediaQuery.of(context).size.width * log.positionX,
                    top: MediaQuery.of(context).size.height * log.positionY,
                    child: GestureDetector(
                      onTap: () => _showLogMessage(context, log.logEntry),
                      child: Image.asset(
                        Assets.imagesIconStar,
                        width: MediaQuery.of(context).size.width / gridCols,
                        height: MediaQuery.of(context).size.width / gridCols,
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _showLogMessage(BuildContext context, LogEntry logEntry) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double width = MediaQuery.of(context).size.width;
        return AlertDialog(
          content: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: width,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: TextWidgets.getMiniTitleText(
                      DateFormat("dd MMM yyyy").format(logEntry.creationDate),
                    )),
                const SizedBox(
                  height: 4,
                ),
                const Divider(
                  thickness: 1,
                  color: TinyLogsColors.buttonDisabled,
                  height: 1,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                  child: TextWidgets.getLogText(logEntry.content),
                )
              ],
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          contentPadding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
          surfaceTintColor: TinyLogsColors.white,
        );
      },
    );
  }

  void updateStarLogOnboardingStatus() {
    OnboardingPreferences.setStarLogOnboardingComplete();
  }
}

class StarLog {
  final LogEntry logEntry;
  final double positionX;
  final double positionY;

  StarLog(this.logEntry, this.positionX, this.positionY);
}

class Point {
  final int x;
  final int y;

  Point(this.x, this.y);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Point &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}
