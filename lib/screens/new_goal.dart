import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosary/enums/pillar_type.dart';
import 'package:rosary/route/route_helpers.dart';

import '../controllers/goal_controller.dart';
import '../controllers/pillar_controller.dart';
import '../enums/motivational_style_type.dart';
import '../widgets/motiv_label.dart';
import '../widgets/primary_button.dart';

enum RepeatOption { none, weekly, monthly, yearly }

class NewGoalPage extends StatefulWidget {
  const NewGoalPage({super.key});

  @override
  State<NewGoalPage> createState() => _NewGoalPageState();
}

class _NewGoalPageState extends State<NewGoalPage> {
  final PillarController pillarC = Get.find<PillarController>();
  final GoalController _goalController = Get.find<GoalController>();

  final TextEditingController goalCtrl = TextEditingController();

  PillarType? selectedPillar;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  RepeatOption repeatOption = RepeatOption.none;
  final Set<int> selectedWeekdays = {};
  int? monthlyDay;
  MotivationStyle motivationStyle = MotivationStyle.gentle;
  String format = "Audio";
  bool both = true;

  @override
  void initState() {
    super.initState();
    if (pillarC.selected.isNotEmpty) {
      selectedPillar = pillarC.selected.first;
    } else if (pillarC.desired.isNotEmpty) {
      selectedPillar = pillarC.desired.first;
    } else {
      selectedPillar = PillarType.personalGrowth;
    }
  }

  @override
  void dispose() {
    goalCtrl.dispose();
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
                Expanded(child: _buildCard(context)),
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
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              color: Colors.white,
            ),
            const Spacer(),
            const SizedBox(width: 44),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          "Create a Goal",
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
  // MAIN CARD
  // ============================================================

  Widget _buildCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Goal ──
            const MotivGoLabel("Goal"),
            const SizedBox(height: 8),
            _TextFieldLike(
              controller: goalCtrl,
              hintText: "e.g. Wake up by 5am",
            ),
            const SizedBox(height: 14),

            // ── Pillar ──
            const MotivGoLabel("Pillar"),
            const SizedBox(height: 8),
            _buildPillarDropdown(),
            const SizedBox(height: 14),

            // ── Time ──
            const MotivGoLabel("Schedule Time"),
            const SizedBox(height: 8),
            _SelectField(
              value: selectedTime == null
                  ? "Select time"
                  : selectedTime!.format(context),
              onTap: _pickTime,
            ),
            const SizedBox(height: 16),

            // ── Repeat ──
            const MotivGoLabel("Repeat"),
            const SizedBox(height: 8),
            _buildRepeatSelector(),
            const SizedBox(height: 16),

            if (repeatOption == RepeatOption.weekly) _buildWeekdaySelector(),

            if (repeatOption == RepeatOption.monthly) _buildMonthlySelector(),

            if (repeatOption == RepeatOption.none) _buildOneTimeDate(),

            const SizedBox(height: 20),

            // ── Motivation Style ──
            const MotivGoLabel("Motivation Style"),
            const SizedBox(height: 8),
            _buildMotivationDropdown(),
            const SizedBox(height: 24),

            // ── Save ──
            MotivGoPrimaryButton(
              text: "Save Goal",
              onPressed: _saveGoal,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // REPEAT SELECTOR
  // ============================================================

  Widget _buildRepeatSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: RepeatOption.values.map((option) {
        final selected = repeatOption == option;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => repeatOption = option),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: selected
                    ? const Color(0xFF7A3DFF)
                    : const Color(0xFFF3F4FF),
              ),
              child: Center(
                child: Text(
                  option.name.capitalizeFirst!,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
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
  // WEEKDAY SELECTOR
  // ============================================================

  Widget _buildWeekdaySelector() {
    const days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MotivGoLabel("Select Days"),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(7, (index) {
            final dayNumber = index == 0 ? 7 : index;
            final selected = selectedWeekdays.contains(dayNumber);

            return GestureDetector(
              onTap: () {
                setState(() {
                  selected
                      ? selectedWeekdays.remove(dayNumber)
                      : selectedWeekdays.add(dayNumber);
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: selected
                      ? const Color(0xFFFF8A3D)
                      : const Color(0xFFF3F4FF),
                ),
                child: Text(
                  days[index],
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : const Color(0xFF2B2E5A),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // ============================================================
  // MONTHLY SELECTOR
  // ============================================================

  Widget _buildMonthlySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MotivGoLabel("Day of Month"),
        const SizedBox(height: 8),
        _SelectField(
          value: monthlyDay == null ? "Select day (1-31)" : "Day $monthlyDay",
          onTap: () async {
            final picked = await showDialog<int>(
              context: context,
              builder: (_) => _DayPickerDialog(),
            );
            if (picked != null) setState(() => monthlyDay = picked);
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // ============================================================
  // ONE TIME DATE
  // ============================================================

  Widget _buildOneTimeDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MotivGoLabel("Schedule Date"),
        const SizedBox(height: 8),
        _SelectField(
          value: selectedDate == null
              ? "Select a date"
              : _formatDate(selectedDate!),
          onTap: _pickDate,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // ============================================================
  // PILLAR DROPDOWN
  // ============================================================

  Widget _buildPillarDropdown() {
    return Obx(() {
      final available = pillarC.selected.isNotEmpty
          ? pillarC.selected.toList()
          : pillarC.desired.toList();

      if (available.isNotEmpty && selectedPillar == null) {
        selectedPillar = available.first;
      }

      return _SelectDropdown<PillarType>(
        value: selectedPillar ?? PillarType.personalGrowth,
        items: available,
        labelBuilder: (p) => p.label,
        onChanged: (p) => setState(() => selectedPillar = p),
      );
    });
  }

  // ============================================================
  // MOTIVATION DROPDOWN
  // ============================================================

  Widget _buildMotivationDropdown() {
    return _SelectDropdown<MotivationStyle>(
      value: motivationStyle,
      items: MotivationStyle.values,
      labelBuilder: (style) => style.label,
      onChanged: (style) {
        if (style != null) setState(() => motivationStyle = style);
      },
    );
  }

  // ============================================================
  // SAVE GOAL
  // ============================================================

  Future<void> _saveGoal() async {
    final goalText = goalCtrl.text.trim();

    if (goalText.isEmpty) {
      Get.snackbar("Missing Goal", "Please enter your goal.",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (selectedTime == null) {
      Get.snackbar("Missing Time", "Please select a time.",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (repeatOption == RepeatOption.weekly && selectedWeekdays.isEmpty) {
      Get.snackbar("Missing Days", "Please select at least one weekday.",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (repeatOption == RepeatOption.monthly && monthlyDay == null) {
      Get.snackbar("Missing Day", "Please select a day of month.",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    DateTime? scheduledAt;
    if (repeatOption == RepeatOption.none) {
      if (selectedDate == null) {
        Get.snackbar("Missing Date", "Please select a date.",
            snackPosition: SnackPosition.BOTTOM);
        return;
      }
      scheduledAt = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );
    }

    final res = await _goalController.saveGoalAndUpdateUser(
      goalTitle: goalText,
      pillar: selectedPillar!.apiValue,
      repeatType: repeatOption.name,
      hour: selectedTime!.hour,
      minute: selectedTime!.minute,
      weekdays: selectedWeekdays.toList(),
      dayOfMonth: monthlyDay,
      scheduledAt: scheduledAt,
      motivationStyle: motivationStyle.apiValue,
      format: format,
      faithToggle: both,
    );

    if (res.isSuccess) {
      // ✅ Show celebration sheet instead of navigating directly
      _showGoalCreatedSheet(goalText);
    } else {
      Get.snackbar("Error", res.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade400,
          colorText: Colors.white);
    }
  }

  // ============================================================
  // 🎉 CELEBRATION BOTTOM SHEET
  // ============================================================

  void _showGoalCreatedSheet(String goalTitle) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
        decoration: const BoxDecoration(
          color: Color(0xFF1A1C3D),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Handle ──
            Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(99),
              ),
            ),

            const SizedBox(height: 28),

            // ── Success Icon ──
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF7B82FF), Color(0xFFFF8A3D)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7B82FF).withOpacity(0.4),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),

            const SizedBox(height: 22),

            // ── Title ──
            const Text(
              "Goal Created! 🎉",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 0.2,
              ),
            ),

            const SizedBox(height: 10),

            // ── Goal name ──
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF7B82FF).withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF7B82FF).withOpacity(0.25),
                  width: 1,
                ),
              ),
              child: Text(
                '"$goalTitle"',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF7B82FF),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // ── Motivational message ──
            const Text(
              "Your alarm is set. Show up every day\nand watch yourself transform. 💪",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.6,
                fontWeight: FontWeight.w500,
                color: Colors.white54,
              ),
            ),

            const SizedBox(height: 30),

            // ── Primary CTA ──
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.back(); // close sheet
                  Get.offAllNamed(RouteHelpers.bottomNav);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B82FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Let's Go 🚀",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── Secondary CTA ──
            TextButton(
              onPressed: () {
                Get.back(); // close sheet
                // Reset form for new goal
                goalCtrl.clear();
                setState(() {
                  selectedTime = null;
                  selectedDate = null;
                  selectedWeekdays.clear();
                  monthlyDay = null;
                  repeatOption = RepeatOption.none;
                  motivationStyle = MotivationStyle.gentle;
                });
              },
              child: const Text(
                "Add Another Goal",
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white38,
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      isDismissible: false, // ✅ force user to pick an action
      enableDrag: false,
    );
  }

  // ============================================================
  // HELPERS
  // ============================================================

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => selectedTime = picked);
  }

  String _formatDate(DateTime d) => "${d.day}/${d.month}/${d.year}";
}

// ============================================================
// DAY PICKER DIALOG
// ============================================================

class _DayPickerDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text(
        "Select Day",
        style: TextStyle(
          fontWeight: FontWeight.w800,
          color: Color(0xFF2B2E5A),
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: List.generate(31, (index) {
            final day = index + 1;
            return InkWell(
              onTap: () => Navigator.pop(context, day),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xFFF3F4FF),
                ),
                child: Center(
                  child: Text(
                    "$day",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2B2E5A),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ============================================================
// REUSABLE WIDGETS
// ============================================================

class _SelectDropdown<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final String Function(T item) labelBuilder;
  final ValueChanged<T> onChanged;

  const _SelectDropdown({
    required this.value,
    required this.items,
    required this.labelBuilder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6E8F5), width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF8E93BD),
          ),
          items: items
              .map((e) => DropdownMenuItem<T>(
                    value: e,
                    child: Text(
                      labelBuilder(e),
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2B2E5A),
                      ),
                    ),
                  ))
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}

class _SelectField extends StatelessWidget {
  final String value;
  final VoidCallback onTap;

  const _SelectField({required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F8FF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE6E8F5), width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2B2E5A),
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Color(0xFF8E93BD),
            ),
          ],
        ),
      ),
    );
  }
}

class _TextFieldLike extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const _TextFieldLike({
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6E8F5), width: 1),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF9AA0C6),
            ),
          ),
          style: const TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2B2E5A),
          ),
        ),
      ),
    );
  }
}
