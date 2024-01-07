import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tinylogs/data/DatabaseHelper.dart';
import 'package:tinylogs/data/LogEntry.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  _LogsPageState createState() => _LogsPageState(); // Renamed to be public
}

class _LogsPageState extends State<LogsPage> {
  List<LogEntry> logs = [];
  DateTime? previousDate;

  @override
  void initState() {
    super.initState();
    loadLogs();
  }

  Future<void> loadLogs() async {
    logs = await DatabaseHelper.instance.queryAllLogs();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: false,
            snap: true,
            floating: true,
            centerTitle: false,
            title: Text(
              "Logs",
              style: TextStyle(
                fontFamily: "SF Pro Display",
                fontWeight: FontWeight.w700,
                fontSize: 34,
                color: Color(0xFFFF6040),
              ),
            ),
            backgroundColor: Colors.white,
          ),
          SliverList.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              var currentDate = log.creationDate;
              bool showDate = !(previousDate?.day == currentDate.day &&
                  previousDate?.month == currentDate.month &&
                  previousDate?.year == currentDate.year);
              previousDate = currentDate;
              return LogItem(log: log, showDate: showDate);
            },
          )
        ],
      ),
    );
  }
}

class LogItem extends StatelessWidget {
  final LogEntry log;
  final bool showDate;

  const LogItem({Key? key, required this.log, this.showDate = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('EEE, MMM d').format(log.creationDate).toUpperCase();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (formattedDate.isNotEmpty && showDate)
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                formattedDate,
                style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              log.content,
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
