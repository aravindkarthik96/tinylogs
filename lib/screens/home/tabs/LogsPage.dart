import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tinylogs/data/DatabaseHelper.dart';
import 'package:tinylogs/data/LogEntry.dart';
import 'package:tinylogs/screens/TinyLogsAddLogPage.dart';

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
    List<LogEntry> updatedLogs = await DatabaseHelper.instance.queryAllLogs();
    setState(() {
      logs = updatedLogs;
    });
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
            title: Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(
                "Logs",
                style: TextStyle(
                  fontFamily: "SF Pro Display",
                  fontWeight: FontWeight.w700,
                  fontSize: 34,
                  color: Color(0xFFFF6040),
                ),
              ),
            ),
            backgroundColor: Colors.white,
          ),
          SliverList.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              var currentDate = log.creationDate;

              var previousDate = index == 0
                  ? null
                  : logs.elementAtOrNull(index - 1)?.creationDate;
              bool showDate = !(previousDate?.day == currentDate.day &&
                  previousDate?.month == currentDate.month &&
                  previousDate?.year == currentDate.year);

              bool showMonth = !(previousDate?.month == currentDate.month &&
                  previousDate?.year == currentDate.year);
              previousDate = currentDate;

              return LogItem(
                log: log,
                showDate: showDate,
                showMonth: showMonth,
                onTap: (logEntry) async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TinyLogsAddLogPage(
                        logEntry: log,
                      ),
                    ),
                  );
                  await loadLogs();
                },
              );
            },
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 100))
        ],
      ),
    );
  }
}

class LogItem extends StatelessWidget {
  final LogEntry log;
  final bool showDate;
  final bool showMonth;
  final Function(LogEntry logEntry) onTap;

  const LogItem(
      {Key? key,
      required this.log,
      this.showDate = false,
      this.showMonth = false,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        getMonthWidget(showMonth),
        getMessageItem(context, log, onTap),
      ],
    );
  }

  Padding getMessageItem(BuildContext context, LogEntry log,
      void Function(LogEntry logEntry) onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: () {
          onTap.call(log);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
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
                image: AssetImage(
                    'assets/images/background_logs_month_separator.png'),
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
