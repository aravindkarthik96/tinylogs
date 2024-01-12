import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tinylogs/commons/widgets/Containers.dart';

import '../../data/logs_data/DatabaseHelper.dart';
import '../../data/logs_data/LogEntry.dart';
import '../../generated/assets.dart';

class LogItem extends StatelessWidget {
  final LogEntry log;
  final bool showDate;
  final bool showMonth;
  final Function(LogEntry logEntry) onTap;

  final bool monthEnabled;
  final bool dateEnabled;
  final EdgeInsets padding;

  const LogItem({
    super.key,
    required this.log,
    this.showDate = false,
    this.showMonth = false,
    required this.onTap,
    this.monthEnabled = false,
    this.dateEnabled = false,
    this.padding = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        monthEnabled ? getMonthWidget(showMonth) : const SizedBox.shrink(),
        getMessageItem(context, log, onTap, dateEnabled),
      ],
    );
  }

  Widget getMessageItem(BuildContext context, LogEntry log,
      void Function(LogEntry logEntry) onTap, bool dateEnabled) {
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          dateEnabled
              ? RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            '${DateFormat('EEE').format(log.creationDate).toUpperCase()}\n',
                        style: TextStyle(
                          fontFamily: "SF Pro Text",
                          color: showDate
                              ? const Color(0xFF6E6E6E)
                              : Colors.transparent,
                          fontWeight: FontWeight.w500,
                          fontSize: 10.0,
                          height: 1.2,
                        ),
                      ),
                      TextSpan(
                        text: DateFormat('d').format(log.creationDate),
                        style: TextStyle(
                          fontFamily: "SF Pro Text",
                          color: showDate ? Colors.black : Colors.transparent,
                          fontWeight: FontWeight.w600,
                          fontSize: 17.0,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
          dateEnabled ? const SizedBox(width: 16.0) : const SizedBox.shrink(),
          Containers.getTappableLog(log.content, () {
            onTap.call(log);
          }),
        ],
      ),
    );
  }

  getMonthWidget(bool showMonth) {
    if (showMonth) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
        child: Container(
          width: double.infinity,
          height: 120,
          alignment: Alignment.centerLeft,
          decoration: const BoxDecoration(
            color: Color(0xFFFFF0E5),
            image: DecorationImage(
                image: AssetImage(Assets.imagesBackgroundLogsMonthSeparator),
                fit: BoxFit.fitHeight,
                alignment: Alignment.topRight),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 0, 16, 0),
                child: Text(
                  DateFormat("MMMM").format(log.creationDate).toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontFamily: "SF Pro Display",
                      fontSize: 26,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                      color: Color(0xFF662619)),
                ),
              ),
              Expanded(
                child: FutureBuilder<String>(
                  future: getMonthPrompt(log.creationDate),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else if (snapshot.hasData) {
                      return Text(
                        snapshot.data!,
                        style: const TextStyle(
                          fontFamily: "SF Pro Text",
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          height: 1.3,
                        ),
                      );
                    } else {
                      return const Text("No data available");
                    }
                  },
                ),
              )
            ],
          ),
        ),
      );
    }
    return const SizedBox();
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
}
