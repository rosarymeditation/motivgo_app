import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motivgo/widgets/primary_button.dart';
import '../controllers/user_controller.dart';
import '../route/route_helpers.dart';
import '../utils/validators.dart';
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
  final _formKey = GlobalKey<FormState>();
  final UserController _userController = Get.find<UserController>();

  bool _obscure = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_userController.hasDeleted.value) {
      return;
    }
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final response = await _userController.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (response.isSuccess) {
      Get.offAllNamed(RouteHelpers.bottomNav);
    } else {
      Get.snackbar(
        "Login Failed",
        response.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade800,
        margin: const EdgeInsets.all(12),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF3F5FF);
    const card = Color(0xFFFFFFFF);
    const line = Color(0xFFE6E8F5);
    const fieldFill = Color(0xFFF7F8FF);

    return Scaffold(
      backgroundColor: bg,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Container(
                // constraints: const BoxConstraints(maxWidth: 430),
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
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.of(context).maybePop(),
                              icon:
                                  const Icon(Icons.arrow_back_ios_new_rounded),
                              color: const Color(0xFF4C4F7C),
                            ),
                            const Spacer(),
                          ],
                        ),

                        const SizedBox(height: 6),
                        const MotivGoH1("Welcome Back"),
                        const SizedBox(height: 10),

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

                        const MotivGoBody(
                          "Log in to continue your motivation journey.",
                          align: TextAlign.center,
                        ),

                        const SizedBox(height: 22),

                        /// EMAIL
                        const MotivGoLabel("Email"),
                        const SizedBox(height: 8),
                        InputWidget(
                          controller: _emailController,
                          hint: "you@example.com",
                          icon: Icons.mail_outline_rounded,
                          fill: fieldFill,
                          border: line,
                          focusNode: _emailFocus,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: AppValidators.validateEmail,
                          onFieldSubmitted: (_) =>
                              _passwordFocus.requestFocus(),
                        ),

                        const SizedBox(height: 16),

                        /// PASSWORD
                        const MotivGoLabel("Password"),
                        const SizedBox(height: 8),
                        InputWidget(
                          controller: _passwordController,
                          hint: "Enter your password",
                          icon: Icons.lock_outline_rounded,
                          fill: fieldFill,
                          border: line,
                          obscureText: _obscure,
                          focusNode: _passwordFocus,
                          textInputAction: TextInputAction.done,
                          validator: AppValidators.validatePassword,
                          onFieldSubmitted: (_) => _submit(),
                          suffix: IconButton(
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility_rounded,
                              size: 18,
                              color: const Color(0xFF9AA0C6),
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        /// LOGIN BUTTON
                        Obx(() => MotivGoPrimaryButton(
                              text: _userController.isLoading.value
                                  ? "Logging In..."
                                  : "Log In",
                              onPressed: _userController.isLoading.value
                                  ? null
                                  : _submit,
                            )),

                        const Spacer(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const MotivGoCaption("Don’t have an account? "),
                            MotivGoLink(
                              text: "Sign Up",
                              onTap: () {
                                Get.toNamed(RouteHelpers.registerPage);
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
        ),
      ),
    );
  }
}
