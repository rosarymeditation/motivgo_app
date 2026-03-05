import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:motivgo/controllers/user_controller.dart';
import 'package:motivgo/model/premium_model.dart';
import 'package:motivgo/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/hive_storage.dart';

class SubscriptionController extends GetxController {
  final UserController _userController = Get.find<UserController>();

  var isSubscribed = false.obs;
  var isPurchasing = false.obs;

  late ConfettiController confettiController;

  @override
  void onInit() {
    super.onInit();
    confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    checkAndRevertTier();
    // checkSubscriptionStatus();
  }

  /// ---------------------------
  /// CHECK & CACHE SUBSCRIPTION
  /// ---------------------------
  // Future<void> checkSubscriptionStatus() async {
  //   final prefs = await SharedPreferences.getInstance();

  //   try {
  //     final customerInfo = await Purchases.getCustomerInfo();
  //     final entitlement =
  //         customerInfo.entitlements.all[AppConstant.entitltment];
  //     final active = entitlement?.isActive ?? false;

  //     isSubscribed.value = active;
  //     await prefs.setBool(AppConstant.IS_SUBSCRIBED_KEY, active);

  //     // Update user controller

  //     //await _userController.upgradeToPremium(premiumModel);
  //   } catch (e) {
  //     // Fallback to cached value
  //     isSubscribed.value =
  //         prefs.getBool(AppConstant.IS_SUBSCRIBED_KEY) ?? false;
  //   }
  // }

  /// ---------------------------
  /// PURCHASE PACKAGE
  /// ---------------------------
  Future<void> purchase(Package package, BuildContext context) async {
    final HiveStorage storage = HiveStorage();
    final user = storage.getUser();
    if (user == null) return;
    if (isPurchasing.value) return;

    try {
      isPurchasing.value = true;

      final result = await Purchases.purchasePackage(package);

      // Update user tier in Hive
      await _upgradeUserToPremium(result.customerInfo);

      final entitlement =
          result.customerInfo.entitlements.all[AppConstant.entitltment];
      final active = entitlement?.isActive ?? false;

      if (active) {
        await checkAndRevertTier(); // Sync reactive state + Hive
        confettiSuccess(context); // Celebration!
      } else {
        _showSnack(context, "Purchase completed but premium not activated.");
      }
    } on PlatformException catch (e) {
      if (e.code != PurchasesErrorCode.purchaseCancelledError.toString()) {
        _showSnack(context, "Purchase failed. Please try again.");
      }
    } catch (e) {
      _showSnack(context, "Something went wrong. Please try again.");
    } finally {
      isPurchasing.value = false;
    }
  }

  /// ---------------------------
  /// RESTORE PURCHASES
  /// ---------------------------
  Future<void> restorePurchases(BuildContext context) async {
    try {
      final customerInfo = await Purchases.restorePurchases();
      final entitlement =
          customerInfo.entitlements.all[AppConstant.entitltment];
      final active = entitlement?.isActive ?? false;

      if (active) {
        await checkAndRevertTier();

        confettiSuccess(context);
      } else {
        _showSnack(context, "No active subscription found.");
      }
    } catch (e) {
      _showSnack(context, "Restore failed.");
    }
  }

  /// ---------------------------
  /// SHOW CONFETTI
  /// ---------------------------
  void confettiSuccess(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            ConfettiWidget(
              confettiController: confettiController,
              blastDirection: -pi / 2,
              emissionFrequency: 0.05,
              numberOfParticles: 30,
              gravity: 0.2,
              shouldLoop: false,
            ),
            Container(
              margin: const EdgeInsets.only(top: 40),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.celebration, color: Colors.amber, size: 60),
                  const SizedBox(height: 20),
                  const Text("You're now a Premium Member!"),
                  const SizedBox(height: 10),
                  const Text(
                      "Enjoy all your benefits and start connecting now."),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Start Browsing Matches"),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      confettiController.play();
    });
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _upgradeUserToPremium(CustomerInfo customerInfo) async {
    final HiveStorage storage = HiveStorage();
    final user = storage.getUser();
    if (user == null) return;

    user.tier = "premium";
    user.updatedAt = DateTime.now();
    await storage.saveUser(user);

    isSubscribed.value = true;
    // confettiSuccessWidget(Get.context!);
  }

  Future<void> checkAndRevertTier() async {
    final HiveStorage storage = HiveStorage();
    final user = storage.getUser();
    if (user == null) return;

    try {
      final customerInfo = await Purchases.getCustomerInfo();
      final entitlement =
          customerInfo.entitlements.all[AppConstant.entitltment];
      final isActive = entitlement?.isActive ?? false;

      if (!isActive && user.tier == "premium") {
        user.tier = "free";
        user.updatedAt = DateTime.now();
        await storage.saveUser(user);
        isSubscribed.value = false;
      } else if (isActive && user.tier != "premium") {
        user.tier = "premium";
        await storage.saveUser(user);
        isSubscribed.value = true;
      }
    } catch (_) {
      // fallback to Hive
      isSubscribed.value = user.tier == "premium";
    }
  }

  @override
  void onClose() {
    confettiController.dispose();
    super.onClose();
  }
}
