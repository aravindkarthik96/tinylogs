import 'dart:ffi';

class LogEntry {
  int?  logID;
  DateTime creationDate;
  String content;
  DateTime lastUpdated;

  LogEntry({this.logID, required this.creationDate, required this.content, required this.lastUpdated});

  Map<String, dynamic> toMap() {
    return {
      'id': logID,
      'creationDate': creationDate.toIso8601String(),
      'content': content,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory LogEntry.fromMap(Map<String, dynamic> map) {
    return LogEntry(
      logID: map['id'],
      creationDate: DateTime.parse(map['creationDate']),
      content: map['content'],
      lastUpdated: DateTime.parse(map['lastUpdated']),
    );
  }
}