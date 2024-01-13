import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tinylogs/commons/resources/TinyLogsColors.dart';
import 'package:tinylogs/commons/resources/TinyLogsStrings.dart';
import 'package:tinylogs/commons/widgets/ButtonWidgets.dart';
import 'package:tinylogs/commons/widgets/TextWidgets.dart';
import 'package:tinylogs/data/logs_data/DatabaseHelper.dart';
import 'package:tinylogs/generated/assets.dart';
import 'package:tinylogs/screens/AddLogPage.dart';
import '../../../commons/notifications/NotificationPopup.dart';
import '../../../commons/widgets/Containers.dart';
import '../../../commons/widgets/LogItem.dart';
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
  bool _loading = false;
  bool _shouldShowNotificationPrompt = false;

  @override
  void initState() {
    loadLogs();
    _loadNotificationStatus();
    super.initState();
  }

  Future<void> loadLogs() async {
    setState(() {
      _loading = true;
    });
    var newLogs = await DatabaseHelper.instance.queryTodayLog();
    setState(() {
      logs = newLogs;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ButtonWidgets.getFloatingActionButton(
          Assets.imagesIconEditFab, () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddLogPage()),
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
          ? SliverToBoxAdapter(
              child: Containers.getPromptBox(
                TodayPageStrings.notificationTitle,
                TodayPageStrings.notificationDescription,
                TodayPageStrings.notificationButtonText,
                () async {
                  await NotificationsPreferences.setNotificationDialogueDismissed();
                  setState(() {
                    _loadNotificationStatus();
                  });
                },
                () async {
                  await showNotificationPopup(context);
                  setState(() {
                    _loadNotificationStatus();
                  });
                },
              ),
            )
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
    if (_loading) {
      return const SliverToBoxAdapter();
    }
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
          monthEnabled: false,
          dateEnabled: false,
          onTap: (logEntry) async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddLogPage(
                  logEntry: log,
                ),
              ),
            );
            await loadLogs();
          },
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 8.0),
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

  Future _loadNotificationStatus() async {
    var notificationDialogueDismissed =
        await NotificationsPreferences.getNotificationDialogueDismissed();
    var notificationConfigured =
        await NotificationsPreferences.getNotificationConfigured();
    setState(() {
      _shouldShowNotificationPrompt =
          !notificationConfigured && (!notificationDialogueDismissed);
    });
  }
}
