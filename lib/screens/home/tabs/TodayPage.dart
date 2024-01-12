import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tinylogs/data/logs_data/DatabaseHelper.dart';
import 'package:tinylogs/screens/TinyLogsAddLogPage.dart';

import '../../../commons/resources/Shadows.dart';
import '../../../commons/notifications/NotificationPopup.dart';
import '../../../data/logs_data/LogEntry.dart';
import '../../../data/notifications/NotificationsPreferences.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({super.key});

  @override
  _TodayPageState createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  List<LogEntry> logs = [];

  bool _shouldShowNotificationPrompt = false;

  @override
  void initState() {
    loadLogs();
    super.initState();
    _loadNotificationStatus();
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
            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const TinyLogsAddLogPage()),
            );
            setState(() {
              loadLogs();
            });
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
        slivers: getSliversList(),
      ),
      backgroundColor: const Color(0xFFFFF0E5),
    );
  }

  List<Widget> getSliversList() {
    return <Widget>[
      getSliverAppBar(),
      const SliverPadding(padding: EdgeInsets.only(top: 32)),
      _shouldShowNotificationPrompt
          ? SliverToBoxAdapter(child: buildNotificationBox())
          : const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 0),
              ),
            ),
      getContentView(),
      const SliverPadding(padding: EdgeInsets.only(bottom: 100))
    ];
  }

  Widget getContentView() {
    if (logs.isNotEmpty) {
      return createLogList();
    } else {
      return createEmptyPage();
    }
  }

  SliverAppBar getSliverAppBar() {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      pinned: true,
      snap: true,
      floating: true,
      centerTitle: false,
      title: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Column(
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

  Widget createEmptyPage() {
    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: _shouldShowNotificationPrompt
              ? const EdgeInsets.fromLTRB(46, 16, 46, 0)
              : const EdgeInsets.fromLTRB(46, 168, 46, 0),
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
                height: 8,
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

  Widget buildNotificationBox() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 0, 28, 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: const Color(0xFFFFB5A6), width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      textAlign: TextAlign.left,
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "Set Notification",
                            style: TextStyle(
                              fontFamily: "SF Pro Display",
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF662619),
                            ),
                          ),
                          TextSpan(
                            text:
                                "\nResearch suggests consistency is key to reap the most benefits. ",
                            style: TextStyle(
                              fontFamily: "SF Pro Display",
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF662619),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextButton(
                      onPressed: () {
                        showNotificationPopup(context);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.fromLTRB(8, 0, 8, 0)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: const BorderSide(
                              color: Color(0xFF662619), width: 1),
                        )),
                      ),
                      child: const Text(
                        'Set notification',
                        style: TextStyle(
                          fontFamily: "SF Pro Display",
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF662619),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  NotificationsPreferences.setNotificationDialogueDismissed();
                  setState(() {
                    _shouldShowNotificationPrompt = false;
                  });
                },
                icon: Image.asset(
                  "assets/images/icon_cross.png",
                  width: 12.5,
                  height: 12.5,
                ))
          ],
        ),
      ),
    );
  }

  Future _loadNotificationStatus() async {
    var notificationDialogueDismissed =
        await NotificationsPreferences.getNotificationDialogueDismissed();
    var notificationConfigured =
        await NotificationsPreferences.getNotificationConfigured();
    setState(() {
      _shouldShowNotificationPrompt =
          (!notificationDialogueDismissed) || notificationConfigured;
    });
  }
}

class LogItem extends StatelessWidget {
  final LogEntry log;
  final bool showDate;
  final bool showMonth;
  final Function(LogEntry logEntry) onTap;

  const LogItem(
      {super.key,
      required this.log,
      this.showDate = false,
      this.showMonth = false,
      required this.onTap});

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
            borderRadius: BorderRadius.circular(8),
            boxShadow: Shadows.getCardShadow(),
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
