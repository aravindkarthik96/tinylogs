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
            pinned: true,
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

              var previousDate = index == 0 ? null : logs.elementAtOrNull(index - 1)?.creationDate;
              bool showDate = !(previousDate?.day == currentDate.day &&
                  previousDate?.month == currentDate.month &&
                  previousDate?.year == currentDate.year);

              bool showMonth = !(previousDate?.month == currentDate.month &&
                  previousDate?.year == currentDate.year);
              previousDate = currentDate;

              return LogItem(
                  log: log, showDate: showDate, showMonth: showMonth);
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
  final bool showMonth;

  const LogItem(
      {Key? key,
      required this.log,
      this.showDate = false,
      this.showMonth = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        getMonthWidget(showMonth),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('EEE\nMMM d').format(log.creationDate).toUpperCase(),
                style: TextStyle(
                  color: showDate ? Colors.black54 : const Color(0x00000000),
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(width: 16.0),
              Expanded(
                  child: Container(
                padding: const EdgeInsets.all(16.0),
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
              )),
            ],
          ),
        ),
      ],
    );
  }

  getMonthWidget(bool showMonth) {
    if (showMonth) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
        child: Container(
          width: double.infinity,
          height: showMonth ? 120 : 0,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF0E5),
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
            DateFormat("MMM").format(log.creationDate).toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontFamily: "SF Pro Display",
                fontSize: 26,
                fontWeight: FontWeight.w400,
                height: 1.2,
                color: Color(0xFF662619)),
          ),
        ),
      );
    }
    return SizedBox();
  }
}
