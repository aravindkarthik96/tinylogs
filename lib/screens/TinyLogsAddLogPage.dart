import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:tinylogs/data/LogEntry.dart';
import 'package:tinylogs/screens/TinyLogsHomePage.dart' show TinyLogsHomePage;

import '../data/DatabaseHelper.dart';

class TinyLogsAddLogPage extends StatefulWidget {
  const TinyLogsAddLogPage({super.key});

  @override
  State<TinyLogsAddLogPage> createState() => _TinyLogsAddLogPageState();
}

class _TinyLogsAddLogPageState extends State<TinyLogsAddLogPage> {
  DateTime selectedDate = DateTime.now();
  bool submitButtonEnabled = false;
  String logText = "";

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
            'assets/images/arrow_left.png',
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
                    letterSpacing: -0.02,
                    color: Color(0xFF662619),
                    height: 1.41,
                  )),
              Image.asset(
                'assets/images/arrow_drop_down.png',
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
                  ? () {
                      storeLog();
                      navigateToNextPage(context);
                    }
                  : null,
              child: Text(
                'Done',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 17.0,
                  letterSpacing: -0.02,
                  color: submitButtonEnabled
                      ? const Color(0xFF6E6E6E)
                      : const Color(0xFFC8C8C8),
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
            decoration: const InputDecoration.collapsed(
              hintText: 'I am thankful for',
              hintStyle: TextStyle(
                color: Color(0xFFC8C8C8),
                fontSize: 17.0,
                height: 1.4,
                letterSpacing: -0.41,
              ),
            ),
            style: const TextStyle(
              color: Color(0xFF404040),
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
            onPressed: () {},
            icon: Image.asset(
              "assets/images/icon_share.png",
              width: 28,
              height: 28,
              color: submitButtonEnabled
                  ? const Color(0xFF919191)
                  : const Color(0xFFC8C8C8),
            ),
          ),
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Image.asset(
                "assets/images/icon_delete.png",
                width: 28,
                height: 28,
                color: submitButtonEnabled
                    ? const Color(0xFF919191)
                    : const Color(0xFFC8C8C8),
              )),
          const Spacer(),
          !submitButtonEnabled
              ? IconButton(
                  onPressed: () {},
                  icon: Image.asset("assets/images/icon_ask_hint.png",
                      width: 28, height: 28))
              : const SizedBox(),
          const SizedBox(width: 28),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void navigateToNextPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TinyLogsHomePage()),
    );
  }

  Future<void> storeLog() async {
    int id = await DatabaseHelper.instance.insertLog(LogEntry(
        creationDate: selectedDate,
        content: logText,
        lastUpdated: DateTime.now()));

    Fluttertoast.showToast(
        msg: "Log stored with ID $id",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey[800],
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
