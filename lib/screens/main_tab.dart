import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motivgo/screens/dashboard.dart';
import 'package:motivgo/screens/goal/goals.dart';
import 'package:motivgo/screens/insight.dart';
import 'package:motivgo/screens/profile.dart';

import '../controllers/tab_controller.dart';

class MainTab extends StatelessWidget {
  MainTab({Key? key}) : super(key: key);

  final MainTabController tabController = Get.find();

  final List<Widget> _pages = [
    DashboardPage(),
    GoalsPage(),
    InsightPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: _pages[tabController.selectedIndex.value],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: tabController.selectedIndex.value,
            onTap: tabController.changeTab,
            backgroundColor: Colors.black.withOpacity(0.6),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.orange.shade800,
            unselectedItemColor: Colors.white70,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Today",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.track_changes_outlined),
                label: "Goals",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.analytics_outlined),
                activeIcon: Icon(Icons.analytics),
                label: "Insight",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_3_rounded),
                label: "Profile",
              ),
            ],
          ),
        ));
  }
}
