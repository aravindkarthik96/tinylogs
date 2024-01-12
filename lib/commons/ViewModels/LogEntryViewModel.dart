import 'package:tinylogs/data/logs_data/LogEntry.dart';

class LogEntryViewModel {
  LogEntry logEntry;
  bool showDate;
  bool showMonth;
  String monthPrompt;

  LogEntryViewModel(
      {required this.logEntry,
      required this.showDate,
      required this.showMonth,
      required this.monthPrompt});
}
