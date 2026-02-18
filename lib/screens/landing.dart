import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosary/route/route_helpers.dart';
import 'package:rosary/utils/motivGoTheme.dart';

import '../widgets/landing_headline.dart';
import '../widgets/landing_subtitle.dart';
import '../widgets/landing_title.dart';
import '../widgets/link.dart';
import '../widgets/primary_button.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF0E1330),
        child: SafeArea(
          child: Center(
            child: Container(
              width: size.width,
              height: size.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background image
                  const Image(
                    image: AssetImage("assets/images/background.png"),
                    fit: BoxFit.cover,
                  ),

                  // Top overlay
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.center,
                        colors: [
                          Color(0xCC1A1F49),
                          Color(0x661A1F49),
                          Color(0x001A1F49),
                        ],
                      ),
                    ),
                  ),

                  // Bottom overlay
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x001A1F49),
                          Color(0x661A1F49),
                          Color(0xCC1A1F49),
                        ],
                      ),
                    ),
                  ),

                  // Content
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Column(
                      children: [
                        const SizedBox(height: 26),

                        // ✅ Title widget (landing style)
                        const MotivGoLandingTitle("Welcome to MotivGo"),
                        const SizedBox(height: 10),

                        // ✅ Subtitle widget
                        const MotivGoLandingSubtitle(
                          "Stay motivated, show up every day.",
                        ),

                        const Spacer(),

                        // ✅ Middle headline widget
                        const MotivGoLandingHeadline(
                          "Transform your goals\ninto daily encouragement.",
                        ),

                        const SizedBox(height: 18),
                        MotivGoPrimaryButton(text: "Get Started", onPressed:()=> Get.toNamed(RouteHelpers.registerPage)),
                        // Get Started button (kept same)
                        // SizedBox(
                        //   width: double.infinity,
                        //   height: 54,
                        //   child: DecoratedBox(
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(28),
                        //       gradient: const LinearGradient(
                        //         begin: Alignment.centerLeft,
                        //         end: Alignment.centerRight,
                        //         colors: [
                        //           Color(0xFFFF8A3D),
                        //           Color(0xFFFF5B8A),
                        //         ],
                        //       ),
                        //       boxShadow: [
                        //         BoxShadow(
                        //           color:
                        //               const Color(0xFFFF8A3D).withOpacity(0.25),
                        //           blurRadius: 18,
                        //           offset: const Offset(0, 10),
                        //         ),
                        //       ],
                        //     ),
                        //     child: ElevatedButton(
                        //       onPressed: () =>
                        //           Get.toNamed(RouteHelpers.registerPage),
                        //       style: ElevatedButton.styleFrom(
                        //         elevation: 0,
                        //         backgroundColor: Colors.transparent,
                        //         shadowColor: Colors.transparent,
                        //         shape: RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.circular(28),
                        //         ),
                        //       ),
                        //       child: const Text(
                        //         "Get Started",
                        //         style: TextStyle(
                        //           fontSize: 18,
                        //           fontWeight: FontWeight.w700,
                        //           color: Colors.white,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),

                        const SizedBox(height: 14),

                        // ✅ Bottom login row using reusable widgets
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const MotivGoLandingSubtitle(
                              "Already have an account? ",
                            ),
                            MotivGoLink(
                              text: "Log In",
                              color: MotivGoTextTheme.whiteSoft,
                              onTap: () {
                                Get.toNamed(RouteHelpers.loginPage);
                                // TODO: route to login
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 26),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
