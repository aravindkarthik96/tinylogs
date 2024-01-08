import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tinylogs/data/DatabaseHelper.dart';
import 'package:tinylogs/data/LogEntry.dart';
import 'package:tinylogs/screens/TinyLogsAddLogPage.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({super.key});

  @override
  _TodayPageState createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  List<LogEntry> logs = [];

  @override
  void initState() {
    super.initState();
    loadLogs();
  }

  Future<void> loadLogs() async {
    List<LogEntry> updatedLogs = await DatabaseHelper.instance.queryTodayLog();
    setState(() {
      logs = updatedLogs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
        width: 64.0,
        height: 64.0,
        child: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const TinyLogsAddLogPage()),
            );
            setState(() {});
          },
          backgroundColor: Colors.red,
          shape: const CircleBorder(),
          child: Image.asset(
            "assets/images/icon_edit_fab.png",
            width: 24,
            height: 24,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            snap: true,
            floating: true,
            centerTitle: false,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('EEE, DD MMM').format(DateTime.now()),
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontFamily: "SF Pro Display",
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                    color: Color(0xFF662619),
                  ),
                ),
                const Text(
                  "Today",
                  style: TextStyle(
                    fontFamily: "SF Pro Display",
                    fontWeight: FontWeight.w700,
                    fontSize: 34,
                    color: Color(0xFFFF6040),
                  ),
                )
              ],
            ),
            backgroundColor: const Color(0xFFFFF0E5),
          ),
          const SliverPadding(padding: EdgeInsets.only(top: 32)),
          getContentView(),
          const SliverPadding(padding: EdgeInsets.only(bottom: 100))
        ],
      ),
      backgroundColor: const Color(0xFFFFF0E5),
    );
  }

  SliverList createLogList() {
    return SliverList.builder(
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        var currentDate = log.creationDate;

        var previousDate =
            index == 0 ? null : logs.elementAtOrNull(index - 1)?.creationDate;
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
    );
  }

  Widget getContentView() {
    if (logs.isNotEmpty) {
      return createLogList();
    } else {
      return createEmptyPage();
    }
  }

  Widget createEmptyPage() {
    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(46,168,46,0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/icon_today_empty_state.png",
                width: 98.99,
                height: 48.42,
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                "Hola Joao!",
                style: TextStyle(
                  fontFamily: "SF Pro Display",
                  fontWeight: FontWeight.w700,
                  fontSize: 34,
                  color: Color(0xFFFF6040),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                "Research says that being grateful everyday unlocks happiness. Record your first thanks for the day ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "SF Pro Display",
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                  color: Color(0xFF662619),
                ),
              )
            ],
          ),
        ),
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
    return getMessageItem(context, log, onTap);
  }

  Padding getMessageItem(BuildContext context, LogEntry log,
      void Function(LogEntry logEntry) onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 8.0),
      child: InkWell(
        onTap: () {
          onTap.call(log);
        },
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
        ),
      ),
    );
  }
}
