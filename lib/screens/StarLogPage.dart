import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:tinylogs/commons/resources/TinyLogsColors.dart';
import 'package:tinylogs/commons/resources/TinyLogsStrings.dart';
import 'package:tinylogs/commons/widgets/ButtonWidgets.dart';
import 'package:tinylogs/commons/widgets/Containers.dart';
import 'package:tinylogs/commons/widgets/Spacers.dart';
import 'package:tinylogs/data/onboarding/OnboardingPreferences.dart';
import 'dart:math';

import '../commons/resources/TinyLogsStyles.dart';
import '../commons/share/ShareLogHelper.dart';
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
    fetchLogs();
    updateStarLogOnboardingStatus();
    super.initState();
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
        var updatedLog = updatedLogs[logs.length];
        logs.add(StarLog(
          updatedLog,
          position.x / gridCols,
          (adjustedY / gridRows) *
              (usableScreenHeight / MediaQuery.of(context).size.height),
          ValueKey(updatedLog.logID),
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
          children: logs.map(
            (log) {
              const double touchAreaSize = 200.0;
              final double offset = (touchAreaSize -
                      MediaQuery.of(context).size.width / gridCols) /
                  2;

              return Positioned(
                left:
                    MediaQuery.of(context).size.width * log.positionX - offset,
                top:
                    MediaQuery.of(context).size.height * log.positionY - offset,
                child: GestureDetector(
                  onTap: () => _showLogMessageDialogue(context, log.logEntry),
                  child: Container(
                    width: touchAreaSize,
                    height: touchAreaSize,
                    alignment: Alignment.center,
                    child: Draggable(
                      data: log,
                      childWhenDragging: getRotatedStar(0.4),
                      feedback: getRotatedStar(5),
                      child: getRotatedStar(1),
                      onDragEnd: (dragDetails) =>
                          _updateStarPosition(log, dragDetails),
                    ),
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }

  void _updateStarPosition(StarLog log, DraggableDetails details) {
    setState(() {
      log.positionX = details.offset.dx / MediaQuery.of(context).size.width;
      log.positionY = details.offset.dy / MediaQuery.of(context).size.height;
    });
  }

  Future<void> _showLogMessageDialogue(
    BuildContext context,
    LogEntry logEntry,
  ) async {
    await showDialog(
      context: context,
      builder: (
        BuildContext context,
      ) {
        var screenshotController = ScreenshotController();
        return Containers.showLogMessageDialogue(
          context,
          logEntry,
          screenshotController,
          () async {
            ShareLogHelper.captureAndShare(screenshotController);
          },
        );
      },
    );
  }

  Future<void> updateStarLogOnboardingStatus() async {
    await OnboardingPreferences.setStarLogOnboardingComplete();
  }

  Widget getRotatedStar(double scale) {
    double rotationAngle = Random().nextDouble() * 2 * pi;
    return Transform.rotate(
      angle: rotationAngle,
      child: Transform.scale(
        scale: scale,
        child: Image.asset(
          Assets.imagesIconStar,
          width: MediaQuery.of(context).size.width / gridCols,
          height: MediaQuery.of(context).size.width / gridCols,
        ),
      ),
    );
  }
}

class StarLog {
  LogEntry logEntry;
  double positionX;
  double positionY;
  Key key;

  StarLog(this.logEntry, this.positionX, this.positionY, this.key);
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
