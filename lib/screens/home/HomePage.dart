import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tinylogs/screens/home/tabs/InsightsPage.dart';
import 'package:tinylogs/screens/home/tabs/TodayPage.dart';

import 'tabs/LogsPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    const TodayPage(),
    const LogsPage(),
    const InsightsPage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          selectedItemColor: const Color(0xFF662619),
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
      ),
    );
  }
}
