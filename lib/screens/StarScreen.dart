import 'package:flutter/material.dart';
import 'dart:math';

import '../data/logs_data/DatabaseHelper.dart';
import '../data/logs_data/LogEntry.dart';

class StarLogsPage extends StatefulWidget {
  @override
  _StarLogsPageState createState() => _StarLogsPageState();
}

class _StarLogsPageState extends State<StarLogsPage> {
  final int maxStars = 15;
  final int gridRows = 30;
  final int gridCols = 30;
  List<StarLog> logs = [];

  @override
  void initState() {
    super.initState();
    fetchLogs();
  }

  Future<void> fetchLogs() async {
    List<LogEntry> updatedLogs = await DatabaseHelper.instance.queryAllLogs();

    var rng = Random();
    Set<Point> usedPoints = {};

    if(!mounted) return;

    final safePaddingTop = MediaQuery.of(context).padding.top;
    final usableScreenHeight = MediaQuery.of(context).size.height - safePaddingTop - 56;

    while (logs.length < min(updatedLogs.length, maxStars)) {
      var position = Point(
        rng.nextInt(gridCols),
        rng.nextInt(gridRows - (56 / usableScreenHeight * gridRows).floor()),
      );

      final adjustedY = position.y + (56 / usableScreenHeight * gridRows).floor();

      if (!usedPoints.contains(position)) {
        usedPoints.add(position);
        logs.add(StarLog(
          updatedLogs[logs.length],
          position.x / gridCols,
          (adjustedY / gridRows) * (usableScreenHeight / MediaQuery.of(context).size.height),
        ));
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.purple[300]!, Colors.purple[700]!],
          ),
        ),
        child: Stack(
          children: logs
              .map((log) => Positioned(
                    left: MediaQuery.of(context).size.width * log.positionX,
                    top: MediaQuery.of(context).size.height * log.positionY,
                    child: GestureDetector(
                      onTap: () =>
                          _showLogMessage(context, log.logEntry.content),
                      child: Icon(Icons.star,
                          color: Colors.white,
                          size: MediaQuery.of(context).size.width / gridCols),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _showLogMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            child: Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
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
