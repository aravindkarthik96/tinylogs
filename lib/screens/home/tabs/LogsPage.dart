import 'package:flutter/material.dart';
import 'package:tinylogs/commons/resources/TinyLogsStrings.dart';
import 'package:tinylogs/commons/widgets/TextWidgets.dart';
import 'package:tinylogs/data/logs_data/DatabaseHelper.dart';
import 'package:tinylogs/screens/TinyLogsAddLogPage.dart';

import '../../../commons/widgets/LogItem.dart';
import '../../../data/logs_data/LogEntry.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  _LogsPageState createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  List<LogEntry> logs = [];

  @override
  void initState() {
    super.initState();
    loadLogs();
  }

  Future<void> loadLogs() async {
    List<LogEntry> updatedLogs = await DatabaseHelper.instance.queryAllLogs();
    setState(() {
      logs = updatedLogs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            snap: true,
            floating: true,
            centerTitle: false,
            title: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: TextWidgets.getPageTitleText(LogsPageStrings.pageTitle),
            ),
            backgroundColor: Colors.white,
          ),
          SliverList.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              var currentDate = log.creationDate;
              var previousDate = index == 0
                  ? null
                  : logs.elementAtOrNull(index - 1)?.creationDate;
              bool showDate = shouldShowDate(previousDate, currentDate);
              bool showMonth = shouldShowMonth(previousDate, currentDate);
              previousDate = currentDate;

              return LogItem(
                log: log,
                showDate: showDate,
                showMonth: showMonth,
                monthEnabled: true,
                dateEnabled: true,
                onTap: (logEntry) async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TinyLogsAddLogPage(
                        logEntry: log,
                      ),
                    ),
                  );
                  await loadLogs();
                },
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
              );
            },
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 100))
        ],
      ),
    );
  }

  bool shouldShowMonth(DateTime? previousDate, DateTime currentDate) {
    return !(previousDate?.month == currentDate.month &&
        previousDate?.year == currentDate.year);
  }

  bool shouldShowDate(DateTime? previousDate, DateTime currentDate) {
    return !(previousDate?.day == currentDate.day &&
        previousDate?.month == currentDate.month &&
        previousDate?.year == currentDate.year);
  }
}
