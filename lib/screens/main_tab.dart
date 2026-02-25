import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosary/controllers/user_controller.dart';
import 'package:rosary/screens/dashboard.dart';
import 'package:rosary/screens/goals.dart';
import 'package:rosary/screens/insight.dart';
import 'package:rosary/screens/profile.dart';

class MainTab extends StatefulWidget {
  MainTab({super.key});

  @override
  State<MainTab> createState() => _MainTabState();
}

class _MainTabState extends State<MainTab> {
  final List<Widget> _pages = [
    DashboardPage(),
    GoalsPage(),
    QuotePage(),
    ProfilePage()
    //FeedListScreen(),
  ];

  final _userController = Get.find<UserController>();

  int _selectedTab = 0;

  void _handleIndexChanged(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () {
      // _userController.getTimeline();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedTab],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: _handleIndexChanged,
        backgroundColor: Colors.black.withOpacity(0.6),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.orange.shade800,
        unselectedItemColor: Colors.white70,
        items: [
          /// Home
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            activeIcon: Icon(Icons.home),
            label: "Today",
          ),

          /// Match
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes_outlined),
            activeIcon: Icon(Icons.track_changes_outlined),
            label: "Goals",
          ),

          /// Chat (with badge)
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            activeIcon: Icon(Icons.analytics),
            label: "Insight",
          ),

           /// Chat (with badge)
          BottomNavigationBarItem(
            icon: Icon(Icons.person_3_rounded),
            activeIcon: Icon(Icons.person_3_rounded),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
