import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TinyLogsAddLogPage extends StatefulWidget {
  const TinyLogsAddLogPage({super.key});

  @override
  State<TinyLogsAddLogPage> createState() => _TinyLogsAddLogPageState();
}

class _TinyLogsAddLogPageState extends State<TinyLogsAddLogPage> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
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
              Image.asset('assets/images/arrow_drop_down.png',
                  width: 16, height: 16),
            ],
          ),
        ),
        actions: const <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 27),
            child: NakedTextButton(),
          )
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          autofocus: true,
          decoration: InputDecoration.collapsed(
            hintText: 'I am thankful for',
            hintStyle: TextStyle(
              color: Color(0xFFC8C8C8),
              fontSize: 17.0,
              height: 1.4,
              letterSpacing: -0.41,
            ),
          ),
          style: TextStyle(
            color: Color(0xFF404040),
            fontSize: 17.0,
            height: 1.4,
            letterSpacing: -0.41,
          ),
        ),
      ),
      floatingActionButton: Row(
        children: [
          const SizedBox(width: 28),
          IconButton(
              onPressed: () {},
              icon: Image.asset("assets/images/icon_share.png",
                  width: 28, height: 28)),
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Image.asset("assets/images/icon_delete.png",
                  width: 28, height: 28)),
          const Spacer(),
          IconButton(
              onPressed: () {},
              icon: Image.asset("assets/images/icon_ask_hint.png",
                  width: 28, height: 28)),
          const SizedBox(width: 28),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class NakedTextButton extends StatelessWidget {
  const NakedTextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: const Text('Done',
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: 17.0,
            letterSpacing: -0.02,
            color: Color(0xFFC8C8C8),
            height: 1.4,
          )),
    );
  }
}
