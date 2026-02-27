import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:rosary/auth/register.dart';
import 'package:rosary/screens/dashboard.dart';
import 'package:rosary/screens/goal/first_goal.dart';
import 'package:rosary/screens/focus_area.dart';
import 'package:rosary/screens/goal/edit.dart';

import 'package:rosary/screens/landing.dart';
import 'package:rosary/screens/main_tab.dart';
import 'package:rosary/screens/new_goal.dart';
import 'package:rosary/screens/occurrence.dart';
import 'package:rosary/splash/splash_page.dart';

import '../auth/login.dart';

class RouteHelpers {
  static const String landingPage = "/landing-page";

  static const String registerPage = "/register-page";
  static const String loginPage = "/login-page";
  static const String bottomNav = "/bottom-nav-page";
  static const String firstGoalPage = "/first-goal-page";
  static const String editGoalPage = "/edit-goal-page";
  static const String newGoalPage = "/new-goal-page";
  static const String goalOccurrencePage = "/goal-occurrence-page";
  static const String focusAreaPage = "/focus-area-page";
  static const String initial = "/";
  static List<GetPage> routes = [
    GetPage(name: initial, page: () => const SplashScreen()),
    // GetPage(name: reflectionPage, page: () => const ReflectionScreen()),
    // GetPage(name: notificationPage, page: () => const NotificationScreen()),

    //GetPage(name: mysterySelectionPage, page: () => MysterySelectionPage()),

    //GetPage(name: dailyReadingPage, page: () => const DailyReadingScreen()),
    //GetPage(name: wayOfCross, page: () => StationPage()),
    // GetPage(name: emailPage, page: () => ReportScreen()),
    GetPage(name: editGoalPage, page: () => EditGoalPage()),
    GetPage(name: newGoalPage, page: () => NewGoalPage()),
    GetPage(name: goalOccurrencePage, page: () => GoalOccurrencePage()),
    GetPage(name: firstGoalPage, page: () => FirstGoalPage()),
    GetPage(name: bottomNav, page: () => MainTab()),
    GetPage(name: focusAreaPage, page: () => FocusAreasPage()),
    GetPage(name: landingPage, page: () => LandingPage()),
    GetPage(name: loginPage, page: () => LoginPage()),

    GetPage(name: registerPage, page: () => RegisterPage()),
  ];
}
