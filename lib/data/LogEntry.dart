class LogEntry {
  String? logID;
  DateTime creationDate;
  String content;
  DateTime lastUpdated;

  LogEntry({this.logID, required this.creationDate, required this.content, required this.lastUpdated});

  Map<String, dynamic> toMap() {
    return {
      'logID': logID,
      'creationDate': creationDate.toIso8601String(),
      'content': content,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory LogEntry.fromMap(Map<String, dynamic> map) {
    return LogEntry(
      creationDate: DateTime.parse(map['creationDate']),
      content: map['content'],
      lastUpdated: DateTime.parse(map['lastUpdated']),
    );
  }
}