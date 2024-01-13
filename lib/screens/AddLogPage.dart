import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:tinylogs/commons/resources/TinyLogsColors.dart';
import 'package:tinylogs/commons/resources/TinyLogsStrings.dart';
import 'package:tinylogs/generated/assets.dart';
import 'package:tinylogs/screens/home/HomePage.dart'
    show HomePage;
import '../data/logs_data/DatabaseHelper.dart';
import '../data/logs_data/LogEntry.dart';
import '../data/onboarding/OnboardingPreferences.dart';

class AddLogPage extends StatefulWidget {
  final LogEntry? logEntry;

  const AddLogPage({super.key, this.logEntry});

  @override
  State<AddLogPage> createState() => _AddLogPageState();
}

class _AddLogPageState extends State<AddLogPage> {
  DateTime selectedDate = DateTime.now();
  bool submitButtonEnabled = false;
  String logText = "";
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController =
        TextEditingController(text: widget.logEntry?.content ?? '');
    logText = _textController.text;
    submitButtonEnabled = _textController.text.length >= 10;

    if (widget.logEntry != null) {
      selectedDate = widget.logEntry!.creationDate;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _handleTextChanged(String newText) {
    setState(() {
      submitButtonEnabled = newText.length >= 10;
      logText = newText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset(
            Assets.imagesArrowLeft,
            width: 24,
            height: 24,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: InkWell(
          onTap: () => _selectDate(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(DateFormat('dd MMM yyyy').format(selectedDate),
                  style: const TextStyle(
                    fontSize: 17.0,
                    color: TinyLogsColors.orangeDark,
                    height: 1.41,
                  )),
              Image.asset(
                Assets.imagesArrowDropDown,
                width: 16,
                height: 16,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 28),
            child: TextButton(
              onPressed: submitButtonEnabled
                  ? () async {
                      await storeLog();
                      markOnboardingComplete();
                      navigateToNextPage();
                    }
                  : null,
              child: Text(
                AddLogsPageStrings.addLogButtonText,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 17.0,
                  letterSpacing: -0.02,
                  color: submitButtonEnabled
                      ? TinyLogsColors.buttonEnabled
                      : TinyLogsColors.buttonDisabled,
                  height: 1.4,
                ),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
          child: TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            autofocus: true,
            onChanged: _handleTextChanged,
            controller: _textController,
            decoration: InputDecoration.collapsed(
              hintText: AddLogsPageStrings.addLogsHintText,
              hintStyle: TextStyle(
                color: TinyLogsColors.textFieldHintColor,
                fontSize: 17.0,
                height: 1.4,
                letterSpacing: -0.41,
              ),
            ),
            style: TextStyle(
              color: TinyLogsColors.textFieldTextColor,
              fontSize: 17.0,
              height: 1.4,
              letterSpacing: -0.41,
            ),
          ),
        ),
      ),
      floatingActionButton: Row(
        children: [
          const SizedBox(width: 28),
          IconButton(
            onPressed: () {
              String contentToShare =
                  "$logText\n${AddLogsPageStrings.shareContentAppSignature}";
              Share.share(contentToShare,
                  subject: AddLogsPageStrings.shareContentSubject);
            },
            icon: Image.asset(
              Assets.imagesIconShare,
              width: 28,
              height: 28,
              color: submitButtonEnabled
                  ? TinyLogsColors.buttonEnabled
                  : TinyLogsColors.buttonDisabled,
            ),
          ),
          IconButton(
              onPressed: () {
                deleteLogEntry();
                Navigator.of(context).pop();
              },
              icon: Image.asset(
                Assets.imagesIconDelete,
                width: 28,
                height: 28,
                color: submitButtonEnabled
                    ? TinyLogsColors.buttonEnabled
                    : TinyLogsColors.buttonDisabled,
              )),
          const Spacer(),
          const SizedBox(width: 28),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void navigateToNextPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  Future<void> storeLog() async {
    if (widget.logEntry != null) {
      var logEntry = widget.logEntry!;
      await DatabaseHelper.instance.updateLog(LogEntry(
          logID: logEntry.logID,
          creationDate: selectedDate,
          content: logText,
          lastUpdated: DateTime.now()));
    } else {
      await DatabaseHelper.instance.insertLog(LogEntry(
          creationDate: selectedDate,
          content: logText,
          lastUpdated: DateTime.now()));
    }
  }

  void markOnboardingComplete() {
    OnboardingPreferences.setOnboardingComplete();
  }

  Future<void> deleteLogEntry() async {
    var logIDTemp = widget.logEntry?.logID;
    if (logIDTemp != null) {
      await DatabaseHelper.instance.deleteLog(widget.logEntry!.logID!);
    }
  }
}