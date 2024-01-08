import 'package:flutter/material.dart';
import 'package:tinylogs/screens/home/tabs/TodayPage.dart';

import 'tabs/LogsPage.dart';
import '../TinyLogsAddLogPage.dart';

class TinyLogsHomePage extends StatefulWidget {
  const TinyLogsHomePage({super.key});

  @override
  State<StatefulWidget> createState() => _TinyLogsHomePageState();
}

class _TinyLogsHomePageState extends State<TinyLogsHomePage> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    const TodayPage(),
    const LogsPage(),
    const PlaceholderWidget(Colors.blue),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
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
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF662619),
        // Color for the selected item
        unselectedItemColor: const Color(0xFF6E6E6E),
        selectedLabelStyle: const TextStyle(
          fontFamily: 'SF Pro Text',
          fontSize: 12,
          height: 1.3,
          fontWeight: FontWeight.w400,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'SF Pro Display',
          fontSize: 12,
          height: 1.3,
          fontWeight: FontWeight.w400,
        ),
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              _currentIndex == 0
                  ? "assets/images/icon_today_selected.png"
                  : "assets/images/icon_today_normal.png",
              width: 24,
              height: 24,
            ),
            label: 'Today',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _currentIndex == 1
                  ? "assets/images/icon_notes_selected.png"
                  : "assets/images/icon_notes_normal.png",
              width: 24,
              height: 24,
            ),
            label: 'Logs',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _currentIndex == 2
                  ? "assets/images/icon_insights_selected.png"
                  : "assets/images/icon_insights_normal.png",
              width: 24,
              height: 24,
            ),
            label: 'Insights',
          ),
        ],
      ),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final Color color;

  const PlaceholderWidget(this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: const Center(
        child: Text('Tab Content', style: TextStyle(fontSize: 35)),
      ),
    );
  }
}
