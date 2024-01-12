import 'package:tinylogs/data/logs_data/LogEntry.dart';

class TextUtils {
  static int getTotalWordCount(List<LogEntry> logs) {
    int totalWords = 0;

    for (var log in logs) {
      List<String> words = log.content.split(RegExp(r'\s+'));

      words = words.where((word) => word.isNotEmpty).toList();

      totalWords += words.length;
    }

    return totalWords;
  }
}
