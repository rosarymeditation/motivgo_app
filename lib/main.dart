import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:rosary/controllers/pillar_controller.dart';
import 'package:rosary/model/goal_model.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'controllers/goal_controller.dart';
import 'controllers/user_controller.dart';
import 'model/goal_occurrence_model.dart';
import 'model/user_model.dart';
import 'route/route_helpers.dart';
import 'service/midnight_trigger.dart';
import 'service/seed_service.dart';
import 'themes/my_themes.dart';
import 'utils/hive_storage.dart';
import 'utils/messages.dart';
import 'utils/notification_service.dart';
import 'helpers/dependencies.dart' as dep;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1️⃣ Initialize Timezone
  tz.initializeTimeZones();

  // 2️⃣ Initialize Hive + Register Adapters
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(UserModelAdapter());
  if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(GoalModelAdapter());
  if (!Hive.isAdapterRegistered(5))
    Hive.registerAdapter(GoalOccurrenceStatusAdapter()); // enum first
  if (!Hive.isAdapterRegistered(2))
    Hive.registerAdapter(GoalOccurrenceAdapter()); // class second

  // 3️⃣ Open Hive Boxes
  if (!Hive.isBoxOpen(HiveStorage.userBox)) {
    await Hive.openBox<UserModel>(HiveStorage.userBox);
  }
  if (!Hive.isBoxOpen('authBox')) {
    await Hive.openBox('authBox');
  }
  if (!Hive.isBoxOpen(HiveStorage.goalBox)) {
    await Hive.openBox<GoalModel>(HiveStorage.goalBox);
  }
  if (!Hive.isBoxOpen('goal_occurrences')) {
    await Hive.openBox<GoalOccurrence>('goal_occurrences');
  }
  await SeedService.resetAndReseed();
  // 4️⃣ Initialize Services & Dependencies (GetX, repos, etc.)
  Map<String, Map<String, String>> languages = await dep.init();

  // 5️⃣ Initialize Controllers
  Get.put(
    UserController(userRepo: Get.find()),
    permanent: true,
  );
  Get.put(GoalController(userRepo: Get.find()));
   Get.put(PillarController());

  // 6️⃣ Initialize Local Notifications (AlarmService)
  await Future.wait([AlarmService().init()]);

  // 7️⃣ Initialize Midnight Trigger — AFTER boxes, deps & controllers are ready
  await MidnightTrigger.init();
  await MidnightTrigger.schedule();
  await MidnightTrigger
      .catchUpMissedOccurrences(); // ✅ goals box is open and populated

  // 8️⃣ Configure RevenueCat
  await Purchases.setDebugLogsEnabled(true);
  await Purchases.configure(
    PurchasesConfiguration(
      Platform.isAndroid
          ? "goog_iFICCzMVnWMsuOBPBJbWwSsSLCa"
          : "appl_GxGpvrKjpVrggJvMgzgyNIbbUvL",
    ),
  );

  // 9️⃣ Run the App
  runApp(MyApp(languages: languages));
}

// ----------------------------
// OneSignal initialization (disabled for now)
// ----------------------------
Future<void> initOneSignal() async {
  final oneSignalAppId = Platform.isAndroid
      ? "3e329aeb-13ad-40e6-a204-15e11f37a968"
      : "9689afb9-bd7f-4f10-8a06-a9e5d9e1b43d";
  // await OneSignal.shared.setAppId(oneSignalAppId);
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

  void _dismissKeyboard() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

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
