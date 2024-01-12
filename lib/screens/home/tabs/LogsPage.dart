import 'package:flutter/material.dart';
import 'package:tinylogs/commons/ViewModels/LogEntryViewModel.dart';
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
  List<LogEntryViewModel> logsViewModels = [];

  @override
  void initState() {
    super.initState();
    loadLogs();
  }

  Future<void> loadLogs() async {
    List<LogEntry> updatedLogs = await DatabaseHelper.instance.queryAllLogs();
    List<LogEntryViewModel> logViewModels =
        await mapLogEntriesToLogEntryViewModels(updatedLogs);
    setState(() {
      logsViewModels = logViewModels;
    });
  }

  Future<List<LogEntryViewModel>> mapLogEntriesToLogEntryViewModels(
    List<LogEntry> logsList,
  ) async {
    List<LogEntryViewModel> logViewModels = [];

    for (final (index, log) in logsList.indexed) {
      var currentDate = log.creationDate;
      var previousDate =
          index == 0 ? null : logsList.elementAtOrNull(index - 1)?.creationDate;
      bool showDate = shouldShowDate(previousDate, currentDate);
      bool showMonth = shouldShowMonth(previousDate, currentDate);
      previousDate = currentDate;
      String monthPrompt = await getMonthPrompt(log.creationDate);

      logViewModels.add(
        LogEntryViewModel(
          logEntry: log,
          showDate: showDate,
          showMonth: showMonth,
          monthPrompt: monthPrompt,
        ),
      );
    }

    return logViewModels;
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
            itemCount: logsViewModels.length,
            itemBuilder: (context, index) {
              var logsViewModel = logsViewModels[index];
              return LogItem(
                log: logsViewModel.logEntry,
                showDate: logsViewModel.showDate,
                showMonth: logsViewModel.showMonth,
                monthPrompt: logsViewModel.monthPrompt,
                monthEnabled: true,
                dateEnabled: true,
                onTap: (logEntry) async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TinyLogsAddLogPage(
                        logEntry: logsViewModel.logEntry,
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

  Future<String> getMonthPrompt(DateTime creationDate) async {
    int count = await DatabaseHelper.instance
        .getMonthlyCount(creationDate.month, creationDate.year);
    var currentDate = DateTime.now();

    String logPlural = count == 1 ? "log" : "logs";

    if (currentDate.month == creationDate.month &&
        currentDate.year == creationDate.year) {
      return "$count $logPlural and counting!";
    }

    return "$count $logPlural!";
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
