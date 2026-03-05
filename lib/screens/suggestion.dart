import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motivgo/model/suggestion_model.dart';
import 'package:motivgo/model/response_model.dart';

import '../controllers/suggestion_controller.dart';

class SuggestionPage extends StatefulWidget {
  const SuggestionPage({super.key});

  @override
  State<SuggestionPage> createState() => _SuggestionPageState();
}

class _SuggestionPageState extends State<SuggestionPage> {
  final SuggestionController controller = Get.find<SuggestionController>();

  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController descriptionCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();

  SuggestionType selectedType = SuggestionType.feature;
  bool allowContact = false;

  @override
  void dispose() {
    titleCtrl.dispose();
    descriptionCtrl.dispose();
    emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bgTop = Color(0xFF4B3D8F);
    const bgMid = Color(0xFF6A3A7C);
    const bgBottom = Color(0xFFFF8A3D);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [bgTop, bgMid, bgBottom],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 14),
                Expanded(child: _buildCard()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              color: Colors.white,
            ),
            const Spacer(),
            const SizedBox(width: 44),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          "App Suggestions",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CARD
  // ============================================================

  Widget _buildCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.96),
        borderRadius: BorderRadius.circular(22),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label("Type"),
            const SizedBox(height: 8),
            _buildTypeSelector(),
            const SizedBox(height: 18),
            _label("Title"),
            const SizedBox(height: 8),
            _textField(
              controller: titleCtrl,
              hint: "Short summary of your suggestion",
            ),
            const SizedBox(height: 18),
            _label("Details"),
            const SizedBox(height: 8),
            _multiLineField(
              controller: descriptionCtrl,
              hint: "Describe your idea or issue in detail...",
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Checkbox(
                  value: allowContact,
                  onChanged: (v) => setState(() => allowContact = v ?? false),
                ),
                const Expanded(
                  child: Text(
                    "Allow us to contact you",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            if (allowContact) ...[
              const SizedBox(height: 12),
              _textField(
                controller: emailCtrl,
                hint: "Your email address",
              ),
            ],
            const SizedBox(height: 28),
            Obx(() => _primaryButton(
                  text: controller.isLoading.value
                      ? "Submitting..."
                      : "Submit Suggestion",
                  onPressed:
                      controller.isLoading.value ? null : _submitSuggestion,
                )),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TYPE SELECTOR
  // ============================================================

  Widget _buildTypeSelector() {
    return Row(
      children: SuggestionType.values.map((type) {
        final selected = selectedType == type;

        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => selectedType = type),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: selected
                    ? const Color(0xFF7A3DFF)
                    : const Color(0xFFF3F4FF),
              ),
              child: Center(
                child: Text(
                  type.name.capitalizeFirst!,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : const Color(0xFF2B2E5A),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ============================================================
  // COMPONENTS
  // ============================================================

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 14,
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _multiLineField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      maxLines: 5,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _primaryButton({
    required String text,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7A3DFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(text),
      ),
    );
  }

  // ============================================================
  // SUBMIT
  // ============================================================

  Future<void> _submitSuggestion() async {
    final title = titleCtrl.text.trim();
    final details = descriptionCtrl.text.trim();
    final email = emailCtrl.text.trim();

    if (title.isEmpty) {
      _showMessage("Please enter a title.");
      return;
    }

    if (details.isEmpty) {
      _showMessage("Please describe your suggestion.");
      return;
    }

    if (allowContact && email.isEmpty) {
      _showMessage("Please enter your email.");
      return;
    }

    final suggestion = SuggestionModel(
      type: selectedType,
      title: title,
      description: details,
      allowContact: allowContact,
      email: allowContact ? email : null,
    );

    ResponseModel result = await controller.sendSuggestion(suggestion);

    if (result.isSuccess) {
      _showMessage("Thank you! Your suggestion was submitted.");
      _resetForm();
    } else {
      _showMessage(result.message);
    }
  }

  void _resetForm() {
    titleCtrl.clear();
    descriptionCtrl.clear();
    emailCtrl.clear();
    setState(() {
      allowContact = false;
      selectedType = SuggestionType.feature;
    });
  }

  void _showMessage(String message) {
    Get.snackbar(
      "Notice",
      message,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
