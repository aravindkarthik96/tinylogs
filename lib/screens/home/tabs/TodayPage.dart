import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tinylogs/commons/resources/TinyLogsColors.dart';
import 'package:tinylogs/commons/resources/TinyLogsStrings.dart';
import 'package:tinylogs/commons/widgets/ButtonWidgets.dart';
import 'package:tinylogs/commons/widgets/TextWidgets.dart';
import 'package:tinylogs/data/logs_data/DatabaseHelper.dart';
import 'package:tinylogs/generated/assets.dart';
import 'package:tinylogs/screens/TinyLogsAddLogPage.dart';
import '../../../commons/notifications/NotificationPopup.dart';
import '../../../commons/widgets/Containers.dart';
import '../../../commons/widgets/Spacers.dart';
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
      floatingActionButton: ButtonWidgets.getFloatingActionButton(
          Assets.imagesIconEditFab, () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TinyLogsAddLogPage()),
        );
        setState(() {
          loadLogs();
        });
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: CustomScrollView(
        slivers: getSliversList(),
      ),
      backgroundColor: TinyLogsColors.orangePageBackground,
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
            TextWidgets.getMiniTitleText(
              DateFormat('EEE, DD MMM').format(DateTime.now()),
            ),
            TextWidgets.getPageTitleText(TodayPageStrings.pageTitle)
          ],
        ),
      ),
      backgroundColor: TinyLogsColors.orangePageBackground,
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
                Assets.imagesIconTodayEmptyState,
                width: 96,
                height: 48,
              ),
              Spacers.sixteenPx,
              TextWidgets.getPageTitleText(TodayPageStrings.emptyPageTitle),
              Spacers.eightPx,
              TextWidgets.getSentenceRegularText(
                  TodayPageStrings.emptyPageDescription)
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
          border: Border.all(color: TinyLogsColors.orangeLight, width: 1),
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
                    TextWidgets.getSmallTitleDescription(
                      TodayPageStrings.notificationTitle,
                      TodayPageStrings.notificationDescription,
                    ),
                    Spacers.twelvePx,
                    ButtonWidgets.getSmallNakedButton(
                        TodayPageStrings.notificationButtonText, () {
                      showNotificationPopup(context);
                    })
                  ],
                ),
              ),
            ),
            ButtonWidgets.getIconButton(Assets.imagesIconCross, () {
              NotificationsPreferences.setNotificationDialogueDismissed();
              setState(() {
                _shouldShowNotificationPrompt = false;
              });
            })
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
      child: Containers.getTappableLog(log.content, () {
        onTap.call(log);
      }),
    );
  }
}
