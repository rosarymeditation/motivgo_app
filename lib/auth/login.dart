import 'package:flutter/material.dart';
import 'package:rosary/widgets/primary_button.dart';
import '../widgets/caption.dart';
import '../widgets/input_widget.dart';
import '../widgets/link.dart';
import '../widgets/motiv_body.dart';
import '../widgets/motiv_h1.dart';
import '../widgets/motiv_label.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscure = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // Match your Register screenshot styling
    const bg = Color(0xFFF3F5FF);
    const card = Color(0xFFFFFFFF);
    const line = Color(0xFFE6E8F5);
    const fieldFill = Color(0xFFF7F8FF);

    return Scaffold(
      backgroundColor: bg,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 430),
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A0E1330),
                    blurRadius: 28,
                    offset: Offset(0, 18),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
                child: Column(
                  children: [
                    // Top row
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).maybePop(),
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          color: const Color(0xFF4C4F7C),
                        ),
                        const Spacer(),
                        const SizedBox(width: 44),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Title
                    const MotivGoH1("Welcome Back"),
                    const SizedBox(height: 10),

                    // Divider with dot
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(height: 1, width: 110, color: line),
                        const SizedBox(width: 8),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF7C82B8),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(height: 1, width: 110, color: line),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Optional subtitle
                    const MotivGoBody(
                      "Log in to continue your motivation journey.",
                      align: TextAlign.center,
                    ),

                    const SizedBox(height: 22),

                    // Email
                    const MotivGoLabel("Email"),
                    const SizedBox(height: 8),
                    InputWidget(
                      controller: _emailController,
                      hint: "Email",
                      icon: Icons.mail_outline_rounded,
                      fill: fieldFill,
                      border: line,
                    ),

                    const SizedBox(height: 16),

                    // Password
                    const MotivGoLabel("Password"),
                    const SizedBox(height: 8),
                    InputWidget(
                      controller: _passwordController,
                      hint: "Password",
                      icon: Icons.lock_outline_rounded,
                      fill: fieldFill,
                      border: line,
                      obscureText: _obscure,
                      suffix: IconButton(
                        onPressed: () => setState(() => _obscure = !_obscure),
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                          size: 18,
                          color: const Color(0xFF9AA0C6),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: MotivGoLink(
                        text: "Forgot password?",
                        onTap: () {
                          // TODO: navigate to forgot password
                        },
                      ),
                    ),

                    const SizedBox(height: 18),
                    MotivGoPrimaryButton(text: "Log In", onPressed: () {}),
                    // Login button
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
                    //           Color(0xFF7A3DFF),
                    //         ],
                    //       ),
                    //       boxShadow: [
                    //         BoxShadow(
                    //           color: const Color(0xFFFF8A3D).withOpacity(0.22),
                    //           blurRadius: 18,
                    //           offset: const Offset(0, 10),
                    //         ),
                    //       ],
                    //     ),
                    //     child: ElevatedButton(
                    //       onPressed: () {
                    //         // TODO: submit login
                    //       },
                    //       style: ElevatedButton.styleFrom(
                    //         elevation: 0,
                    //         backgroundColor: Colors.transparent,
                    //         shadowColor: Colors.transparent,
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(28),
                    //         ),
                    //       ),
                    //       child: const Text(
                    //         "Log In",
                    //         style: TextStyle(
                    //           fontSize: 18,
                    //           fontWeight: FontWeight.w800,
                    //           color: Colors.white,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    SizedBox(height: 14),

                    // Or continue with
                    Row(
                      children: const [
                        Expanded(child: Divider(color: line, thickness: 1)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: MotivGoCaption("Or continue with"),
                        ),
                        Expanded(child: Divider(color: line, thickness: 1)),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Social buttons (same style as register)
                    _SocialButton(
                      label: "Continue with Google",
                      icon: const _GoogleGIcon(),
                      onTap: () {
                        // TODO: Google login
                      },
                    ),
                    const SizedBox(height: 10),
                    _SocialButton(
                      label: "Continue with Apple",
                      icon: const Icon(Icons.apple,
                          size: 22, color: Colors.black),
                      onTap: () {
                        // TODO: Apple login
                      },
                    ),

                    const Spacer(),

                    // Bottom: create account
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const MotivGoCaption("Don’t have an account? "),
                        MotivGoLink(
                          text: "Sign Up",
                          onTap: () {
                            // TODO: go to register
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE6E8F5), width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A0E1330),
              blurRadius: 12,
              offset: Offset(0, 8),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2B2E5A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoogleGIcon extends StatelessWidget {
  const _GoogleGIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFF1F3FF),
      ),
      child: const Center(
        child: Text(
          "G",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: Color(0xFF4285F4),
          ),
        ),
      ),
    );
  }
}
