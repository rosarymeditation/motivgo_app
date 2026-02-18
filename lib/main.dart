import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:rosary/model/goal_model.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'controllers/goal_controller.dart';
import 'controllers/user_controller.dart';
import 'data/repository/user_repo.dart';
import 'model/user_model.dart';
import 'route/route_helpers.dart';
import 'themes/my_themes.dart';
import 'utils/hive_storage.dart';
import 'utils/messages.dart';
import 'utils/notification_service.dart';
import 'helpers/dependencies.dart' as dep;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1️⃣ Initialize Timezone
  tz.initializeTimeZones();

  // 2️⃣ Initialize Hive
  await Hive.initFlutter();
  //   await Hive.deleteBoxFromDisk(HiveStorage.userBox);
  // await Hive.deleteBoxFromDisk(HiveStorage.authBox);
  if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(UserModelAdapter());
  if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(GoalModelAdapter());
  if (!Hive.isBoxOpen(HiveStorage.userBox)) {
    await Hive.openBox<UserModel>(HiveStorage.userBox);
  }
  if (!Hive.isBoxOpen('authBox')) {
    await Hive.openBox('authBox');
  }
   if (!Hive.isBoxOpen(HiveStorage.goalBox)) {
    await Hive.openBox<GoalModel>(HiveStorage.goalBox);
  }

  // 3️⃣ Initialize services and dependencies
  Map<String, Map<String, String>> languages = await dep.init();

  // 4️⃣ Initialize Controllers
  
  Get.put(
    UserController(userRepo: Get.find()),
    permanent: true, // 🔥 VERY IMPORTANT
  );
  Get.put(GoalController(userRepo: Get.find()));

  // 5️⃣ Initialize Local Notifications
  await Future.wait([AlarmService().init()]);

  // 7️⃣ Configure RevenueCat Purchases
  await Purchases.setDebugLogsEnabled(true);
  await Purchases.configure(
    PurchasesConfiguration(
      Platform.isAndroid
          ? "goog_iFICCzMVnWMsuOBPBJbWwSsSLCa"
          : "appl_GxGpvrKjpVrggJvMgzgyNIbbUvL",
    ),
  );

  // 8️⃣ Run the app
  runApp(MyApp(languages: languages));
}

// ----------------------------
// OneSignal initialization
// ----------------------------
Future<void> initOneSignal() async {
  final oneSignalAppId = Platform.isAndroid
      ? "3e329aeb-13ad-40e6-a204-15e11f37a968"
      : "9689afb9-bd7f-4f10-8a06-a9e5d9e1b43d";

  //await OneSignal.shared.setAppId(oneSignalAppId);

  // Request user permission for notifications (iOS)
  // final status = await OneSignal.shared.promptUserForPushNotificationPermission(
  //   fallbackToSettings: true,
  // );
}

// ----------------------------
// Main App Widget
// ----------------------------
class MyApp extends StatefulWidget {
  final Map<String, Map<String, String>> languages;
  const MyApp({super.key, required this.languages});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _checkForUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      useInheritedMediaQuery: true,
      builder: (context, child) => GestureDetector(
        onTap: _dismissKeyboard,
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MotivGo',
          theme: ThemeClass.lightTheme(),
          darkTheme: ThemeClass.darkTheme(),
          themeMode: ThemeMode.system,
          translations: Messages(languages: widget.languages),
          fallbackLocale: const Locale("en", "US"),
          initialRoute: RouteHelpers.initial,
          getPages: RouteHelpers.routes,
        ),
      ),
    );
  }

  // ----------------------------
  // Helper to dismiss keyboard
  // ----------------------------
  void _dismissKeyboard() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  // ----------------------------
  // Check for Android In-App Updates
  // ----------------------------
  Future<void> _checkForUpdate() async {
    if (!Platform.isAndroid) return;
    try {
      final info = await InAppUpdate.checkForUpdate();
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        await InAppUpdate.startFlexibleUpdate();
        await InAppUpdate.completeFlexibleUpdate();
      }
    } catch (e) {
      print("Update check failed: $e");
    }
  }
}
