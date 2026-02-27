import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosary/utils/hive_storage.dart';

import '../controllers/user_controller.dart';
import '../route/route_helpers.dart';
import '../utils/validators.dart';
import '../widgets/caption.dart';
import '../widgets/input_widget.dart';
import '../widgets/link.dart';
import '../widgets/motiv_h1.dart';
import '../widgets/motiv_label.dart';
import '../widgets/primary_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final UserController _userController = Get.find<UserController>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _confirmPasswordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final response = await _userController.register(
      _emailController.text.trim(),
      _passwordController.text.trim(),
      _firstNameController.text.trim(),
    );

    if (response.isSuccess) {
      await HiveStorage.resetAll();
      Get.offAllNamed(RouteHelpers.focusAreaPage);
    } else {
      Get.snackbar(
        "Registration Failed",
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
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
                            child: Form(
                              key: _formKey,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// BACK BUTTON
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () =>
                                            Navigator.of(context).maybePop(),
                                        icon: const Icon(
                                            Icons.arrow_back_ios_new_rounded),
                                        color: const Color(0xFF4C4F7C),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 8),
                                  const MotivGoH1("Create Your Account"),
                                  const SizedBox(height: 24),

                                  /// FIRST NAME
                                  const MotivGoLabel("First Name"),
                                  const SizedBox(height: 8),
                                  InputWidget(
                                    controller: _firstNameController,
                                    hint: "John",
                                    icon: Icons.person,
                                    fill: fieldFill,
                                    border: line,
                                    validator: AppValidators.validateFirstName,
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_) =>
                                        _emailFocus.requestFocus(),
                                  ),

                                  const SizedBox(height: 16),

                                  /// EMAIL
                                  const MotivGoLabel("Email"),
                                  const SizedBox(height: 8),
                                  InputWidget(
                                    controller: _emailController,
                                    hint: "you@example.com",
                                    icon: Icons.mail_outline_rounded,
                                    fill: fieldFill,
                                    border: line,
                                    validator: AppValidators.validateEmail,
                                    focusNode: _emailFocus,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_) =>
                                        _passwordFocus.requestFocus(),
                                  ),

                                  const SizedBox(height: 16),

                                  /// PASSWORD
                                  const MotivGoLabel("Password"),
                                  const SizedBox(height: 8),
                                  InputWidget(
                                    controller: _passwordController,
                                    hint: "Create a strong password",
                                    icon: Icons.lock_outline_rounded,
                                    fill: fieldFill,
                                    border: line,
                                    obscureText: _obscurePassword,
                                    focusNode: _passwordFocus,
                                    textInputAction: TextInputAction.next,
                                    suffix: IconButton(
                                      onPressed: () => setState(() =>
                                          _obscurePassword = !_obscurePassword),
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        size: 18,
                                        color: const Color(0xFF9AA0C6),
                                      ),
                                    ),
                                    validator: AppValidators.validatePassword,
                                    onFieldSubmitted: (_) =>
                                        _confirmFocus.requestFocus(),
                                  ),

                                  const SizedBox(height: 16),

                                  /// CONFIRM PASSWORD
                                  const MotivGoLabel("Confirm Password"),
                                  const SizedBox(height: 8),
                                  InputWidget(
                                    controller: _confirmPasswordController,
                                    hint: "Re-enter password",
                                    icon: Icons.lock_outline_rounded,
                                    fill: fieldFill,
                                    border: line,
                                    obscureText: _obscureConfirm,
                                    focusNode: _confirmFocus,
                                    textInputAction: TextInputAction.done,
                                    suffix: IconButton(
                                      onPressed: () => setState(() =>
                                          _obscureConfirm = !_obscureConfirm),
                                      icon: Icon(
                                        _obscureConfirm
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        size: 18,
                                        color: const Color(0xFF9AA0C6),
                                      ),
                                    ),
                                    validator: (value) =>
                                        AppValidators.validateConfirmPassword(
                                      value,
                                      _passwordController.text,
                                    ),
                                    onFieldSubmitted: (_) => _submit(),
                                  ),

                                  const SizedBox(height: 26),

                                  /// SUBMIT
                                  Obx(() => MotivGoPrimaryButton(
                                        text: _userController.isLoading.value
                                            ? "Creating Account..."
                                            : "Sign Up",
                                        onPressed:
                                            _userController.isLoading.value
                                                ? null
                                                : _submit,
                                      )),

                                  const Spacer(),

                                  /// LOGIN LINK
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const MotivGoCaption(
                                          "Already have an account? "),
                                      MotivGoLink(
                                        text: "Log In",
                                        onTap: () {},
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 12),
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
            },
          ),
        ),
      ),
    );
  }
}
