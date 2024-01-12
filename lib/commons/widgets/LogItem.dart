import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tinylogs/commons/widgets/Containers.dart';
import 'package:tinylogs/commons/widgets/TextWidgets.dart';
import '../../data/logs_data/LogEntry.dart';

class LogItem extends StatelessWidget {
  final LogEntry log;
  final bool showDate;
  final bool showMonth;
  final bool monthEnabled;
  final bool dateEnabled;

  final Function(LogEntry logEntry) onTap;

  final EdgeInsets padding;

  final String monthPrompt;

  const LogItem({
    super.key,
    required this.log,
    this.showDate = false,
    this.showMonth = false,
    required this.onTap,
    this.monthEnabled = false,
    this.dateEnabled = false,
    this.padding = const EdgeInsets.all(0),
    this.monthPrompt = "",
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        monthEnabled && showMonth
            ? Containers.getLogSeparator(
                DateFormat("MMMM").format(log.creationDate).toString(),
                monthPrompt)
            : const SizedBox.shrink(),
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
              ? TextWidgets.getDateText(
                  dayOfWeek:
                      '${DateFormat('EEE').format(log.creationDate).toUpperCase()}\n',
                  dayOfMonth: DateFormat('d').format(log.creationDate),
                  visibility: showDate,
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
}
