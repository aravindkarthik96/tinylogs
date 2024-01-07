import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tinylogs/data/DatabaseHelper.dart';
import 'package:tinylogs/data/LogEntry.dart';

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
    // Retrieve logs from the database and setState
    logs = await DatabaseHelper.instance.queryAllLogs();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar(
            automaticallyImplyLeading: false, // No back button
            pinned: false, // Set to true if you want the AppBar to remain visible when scrolling
            snap: false, // Snap effects
            floating: false,
            centerTitle: false,
            title: Text(
              "Logs",
              style: TextStyle(
                fontFamily: "SF Pro Display",
                fontWeight: FontWeight.w700,
                fontSize: 34,
                color: Color(0xFFFF6040),
                // Note: The 'height' in TextStyle is a multiplier, not a pixel value.
              ),
            ),
            backgroundColor: Colors.white, // Set your desired background color
          ),
          SliverList.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              return LogItem(log: log);
            },
          )
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // No back button
        title: const Text(
          "Logs",
          style: TextStyle(
            fontFamily: "SF Pro Display",
            fontWeight: FontWeight.w700,
            fontSize: 34,
            color: Color(0xFFFF6040),
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: false,
      ),
      body: ListView.builder(
        itemCount: logs.length,
        itemBuilder: (context, index) {
          final log = logs[index];
          return LogItem(log: log);
        },
      ),
    );
  }
}

class LogItem extends StatelessWidget {
  final LogEntry log;

  const LogItem({Key? key, required this.log}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format the date to match the design
    String formattedDate =
        DateFormat('EEE, MMM d').format(log.creationDate).toUpperCase();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (formattedDate.isNotEmpty)
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
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
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
