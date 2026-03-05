import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/subscription_controller.dart';

class PaywallPage extends StatefulWidget {
  const PaywallPage({super.key});

  @override
  State<PaywallPage> createState() => _PaywallPageState();
}

class _PaywallPageState extends State<PaywallPage> {
  final SubscriptionController _subscriptionController =
      Get.find<SubscriptionController>();
  List<Package>? _packages;
  Package? _selectedPackage;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadOfferings();
  }

  /// Load offerings from RevenueCat
  Future<void> _loadOfferings() async {
    try {
      final offerings = await Purchases.getOfferings();
      final offering = offerings.current;

      if (offering != null && offering.availablePackages.isNotEmpty) {
        setState(() {
          _packages = offering.availablePackages;
          _selectedPackage = _packages!.first;
          _isLoading = false;
        });
      } else {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    } catch (_) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  /// Get readable subscription period
  String _getPeriodTitle(Package package) {
    final periodString = package.storeProduct.subscriptionPeriod ?? '';
    if (periodString.contains('W')) return 'Weekly';
    if (periodString.contains('M')) return 'Monthly';
    if (periodString.contains('Y')) return 'Yearly';
    if (periodString.contains('D'))
      return '${periodString.replaceAll(RegExp(r'[^0-9]'), '')} Days';
    return package.storeProduct.title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? const Center(child: Text("Unable to load plans"))
              : Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF1B0F3B),
                            Color(0xFF3A1C71),
                            Color(0xFF5F2C82),
                            Color(0xFFF2994A),
                          ],
                        ),
                      ),
                      child: SafeArea(
                        child: Column(
                          children: [
                            const SizedBox(height: 40),

                            /// Hero
                            const Icon(
                              Icons.emoji_events,
                              size: 120,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Upgrade to Pro",
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 40),

                            /// Pricing Cards
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                alignment: WrapAlignment.center,
                                children: _packages!
                                    .map(
                                      (pkg) => GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedPackage = pkg;
                                          });
                                        },
                                        child: PricingCard(
                                          title: _getPeriodTitle(pkg),
                                          price: pkg.storeProduct.priceString,
                                          isSelected: _selectedPackage == pkg,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                            const Spacer(),

                            /// Buttons
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                children: [
                                  /// Continue / Purchase
                                  Obx(() {
                                    return GestureDetector(
                                      onTap: _selectedPackage == null ||
                                              _subscriptionController
                                                  .isPurchasing.value
                                          ? null
                                          : () =>
                                              _subscriptionController.purchase(
                                                  _selectedPackage!, context),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12.w,
                                                vertical: 8.h),
                                            child: Text(
                                              textAlign: TextAlign.center,
                                              "Subscription automatically renews unless canceled at least 24 hours before the end of the current period. You can manage or cancel your subscription in your Apple ID Account Settings after purchase.",
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),

                                          // ✅ Terms of Use & Privacy Policy Links
                                          Padding(
                                            padding: EdgeInsets.only(top: 12.h),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    // Open Terms of Use
                                                    launchUrl(Uri.parse(
                                                        "https://motivgo.com/terms.html"));
                                                  },
                                                  child: Text(
                                                    "Terms of Use",
                                                    style: TextStyle(
                                                      fontSize: 10.sp,
                                                      color: Colors.white,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 16.w),
                                                GestureDetector(
                                                  onTap: () {
                                                    // Open Privacy Policy
                                                    launchUrl(
                                                      Uri.parse(
                                                          "https://motivgo.com/privacy.html"),
                                                    );
                                                  },
                                                  child: Text(
                                                    "Privacy Policy",
                                                    style: TextStyle(
                                                      fontSize: 10.sp,
                                                      color: Colors.white,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 65,
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [
                                                  Color(0xFFFFD194),
                                                  Color(0xFFFFB347),
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.orange
                                                      .withOpacity(0.5),
                                                  blurRadius: 15,
                                                  spreadRadius: 2,
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: _subscriptionController
                                                      .isPurchasing.value
                                                  ? const CircularProgressIndicator(
                                                      color: Colors.white)
                                                  : const Text(
                                                      "Continue",
                                                      style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                  const SizedBox(height: 16),

                                  /// Restore Button
                                  TextButton(
                                    onPressed: () => _subscriptionController
                                        .restorePurchases(context),
                                    child: const Text(
                                      "Restore Purchases",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    /// Close Button
                    Positioned(
                      top: 40,
                      right: 16,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context, false),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.white.withOpacity(0.3)),
                          ),
                          child: const Icon(Icons.close,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}

class PricingCard extends StatelessWidget {
  final String title;
  final String price;
  final bool isSelected;

  const PricingCard({
    super.key,
    required this.title,
    required this.price,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 110,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: isSelected
            ? const LinearGradient(
                colors: [Color(0xFFFFB75E), Color(0xFFED8F03)])
            : const LinearGradient(
                colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)]),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(title,
              style: const TextStyle(fontSize: 16, color: Colors.white)),
          const SizedBox(height: 12),
          Text(price,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ],
      ),
    );
  }
}
