import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosary/enums/pillar_type.dart';
import 'package:rosary/route/route_helpers.dart';

import '../../controllers/goal_controller.dart';
import '../../controllers/pillar_controller.dart';
import '../../enums/motivational_style_type.dart';
import '../../model/goal_model.dart';
import '../../widgets/motiv_label.dart';
import '../../widgets/primary_button.dart';

enum RepeatOption { none, weekly, monthly, yearly }

class EditGoalPage extends StatefulWidget {
  // ✅ required — pass the goal to edit

  EditGoalPage({
    super.key,
  });

  @override
  State<EditGoalPage> createState() => _EditGoalPageState();
}

class _EditGoalPageState extends State<EditGoalPage> {
  late GoalModel goal;

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
    goal = _goalController.goalForEdit.value!;
    _prefillFromGoal(goal); // ✅ populate all fields from existing goal
  }

  // ============================================================
  // PRE-FILL FROM EXISTING GOAL
  // ============================================================

  void _prefillFromGoal(GoalModel g) {
    //final g = widget.goal;

    // Title
    goalCtrl.text = g.title ?? '';

    // Pillar — locked, just display
    selectedPillar = pillarFromApi(g.pillar ?? 'personal_growth');

    // Time
    if (g.hour != null && g.minute != null) {
      selectedTime = TimeOfDay(hour: g.hour!, minute: g.minute!);
    }

    // Repeat type — locked, just display
    repeatOption = _repeatFromString(g.repeatType);

    // Weekdays
    if (g.weekdays != null) {
      selectedWeekdays.addAll(g.weekdays!);
    }

    // Monthly day
    monthlyDay = g.dayOfMonth;

    // One-time date
    if (g.scheduledAt != null && repeatOption == RepeatOption.none) {
      selectedDate = g.scheduledAt;
    }

    // Motivation style
    // motivationStyle = motivationStyleFromApi(g.motivationStyle ?? 'gentle');

    // Format
    format = g.format ?? 'Audio';

    // Faith toggle
    both = g.faithToggle ?? true;
  }

  RepeatOption _repeatFromString(String? value) {
    switch (value) {
      case 'weekly':
        return RepeatOption.weekly;
      case 'monthly':
        return RepeatOption.monthly;
      case 'yearly':
        return RepeatOption.yearly;
      default:
        return RepeatOption.none;
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
            // ✅ Delete goal button
            IconButton(
              onPressed: _confirmDelete,
              icon: const Icon(Icons.delete_outline_rounded),
              color: Colors.white60,
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          "Edit Goal",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          "Pillar and repeat type cannot be changed",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.white54,
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
            // ── Goal title ──
            const MotivGoLabel("Goal"),
            const SizedBox(height: 8),
            _TextFieldLike(
              controller: goalCtrl,
              hintText: "e.g. Wake up by 5am",
            ),
            const SizedBox(height: 14),

            // ── Pillar — LOCKED ──
            const MotivGoLabel("Pillar"),
            const SizedBox(height: 8),
            _LockedField(
              value: selectedPillar?.label ?? '—',
              icon: Icons.lock_rounded,
              tooltip: "Pillar cannot be changed after creation",
            ),
            const SizedBox(height: 14),

            // ── Time — EDITABLE ──
            const MotivGoLabel("Schedule Time"),
            const SizedBox(height: 8),
            _SelectField(
              value: selectedTime == null
                  ? "Select time"
                  : selectedTime!.format(context),
              onTap: _pickTime,
            ),
            const SizedBox(height: 16),

            // ── Repeat — LOCKED ──
            const MotivGoLabel("Repeat"),
            const SizedBox(height: 8),
            _LockedField(
              value: repeatOption.name.capitalizeFirst!,
              icon: Icons.lock_rounded,
              tooltip: "Repeat type cannot be changed after creation",
            ),
            const SizedBox(height: 16),

            // ── Weekdays — shown but locked ──
            if (repeatOption == RepeatOption.weekly)
              _buildWeekdaySelector(locked: true),

            // ── Monthly day — shown but locked ──
            if (repeatOption == RepeatOption.monthly) _buildMonthlyLocked(),

            // ── One-time date — editable ──
            if (repeatOption == RepeatOption.none) _buildOneTimeDate(),

            const SizedBox(height: 20),

            // ── Motivation Style — EDITABLE ──
            const MotivGoLabel("Motivation Style"),
            const SizedBox(height: 8),
            _buildMotivationDropdown(),
            const SizedBox(height: 24),

            // ── Save ──
            MotivGoPrimaryButton(
              text: "Save Changes",
              onPressed: _saveChanges,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // WEEKDAY SELECTOR (locked in edit mode)
  // ============================================================

  Widget _buildWeekdaySelector({bool locked = false}) {
    const days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const MotivGoLabel("Days"),
            if (locked) ...[
              const SizedBox(width: 8),
              const Icon(Icons.lock_rounded,
                  size: 12, color: Color(0xFF9AA0C6)),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(7, (index) {
            final dayNumber = index == 0 ? 7 : index;
            final selected = selectedWeekdays.contains(dayNumber);

            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: selected
                    ? locked
                        ? const Color(0xFFB0A0FF) // ✅ muted purple if locked
                        : const Color(0xFFFF8A3D)
                    : const Color(0xFFF3F4FF),
              ),
              child: Text(
                days[index],
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: selected ? Colors.white : const Color(0xFF2B2E5A),
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
  // MONTHLY LOCKED
  // ============================================================

  Widget _buildMonthlyLocked() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MotivGoLabel("Day of Month"),
        const SizedBox(height: 8),
        _LockedField(
          value: monthlyDay == null ? "—" : "Day $monthlyDay",
          icon: Icons.lock_rounded,
          tooltip: "Day of month cannot be changed",
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // ============================================================
  // ONE TIME DATE — editable
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
  // SAVE CHANGES
  // ============================================================

  Future<void> _saveChanges() async {
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

    if (repeatOption == RepeatOption.none && selectedDate == null) {
      Get.snackbar("Missing Date", "Please select a date.",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    DateTime? scheduledAt;
    if (repeatOption == RepeatOption.none && selectedDate != null) {
      scheduledAt = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );
    }

    // ✅ Build updated goal — only touch editable fields
    final updatedGoal = goal.copyWith(
      title: goalText,
      hour: selectedTime!.hour,
      minute: selectedTime!.minute,
      scheduledAt: scheduledAt,
      motivationStyle: motivationStyle.apiValue,
      format: format,
      faithToggle: both,
      // pillar, repeatType, weekdays, dayOfMonth — NOT touched
    );

    final res = await _goalController.updateGoal(updatedGoal);

    if (res.isSuccess) {
      _showGoalUpdatedSheet(goalText);
    } else {
      Get.snackbar("Error", res.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade400,
          colorText: Colors.white);
    }
  }

  // ============================================================
  // DELETE
  // ============================================================

  void _confirmDelete() {
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
            Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 24),
            const Icon(Icons.delete_forever_rounded,
                color: Colors.redAccent, size: 48),
            const SizedBox(height: 16),
            const Text(
              "Delete Goal?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "This will remove the goal and all its history.\nThis action cannot be undone.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.5,
                color: Colors.white54,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  Get.back();
                  await _goalController.deleteGoal(goal);
                  Get.offAllNamed(RouteHelpers.bottomNav);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Yes, Delete",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text(
                "Cancel",
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
    );
  }

  // ============================================================
  // ✅ UPDATED SHEET
  // ============================================================

  void _showGoalUpdatedSheet(String goalTitle) {
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
            Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 28),

            // ── Icon ──
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF4CAF50), Color(0xFF7B82FF)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4CAF50).withOpacity(0.4),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.edit_rounded,
                color: Colors.white,
                size: 38,
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              "Goal Updated! ✨",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 10),

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

            const Text(
              "Your changes are saved.\nKeep showing up — you're doing great. 💪",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.6,
                fontWeight: FontWeight.w500,
                color: Colors.white54,
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
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
                  "Back to Goals 🚀",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      isDismissible: false,
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
// LOCKED FIELD — replaces dropdown for non-editable fields
// ============================================================

class _LockedField extends StatelessWidget {
  final String value;
  final IconData icon;
  final String tooltip;

  const _LockedField({
    required this.value,
    required this.icon,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F8), // slightly greyed
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E2F0), width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF9AA0C6), // muted text = locked
                ),
              ),
            ),
            Icon(icon, size: 14, color: const Color(0xFF9AA0C6)),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// REUSABLE WIDGETS (same as NewGoalPage)
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
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: Color(0xFF8E93BD)),
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
            const Icon(Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF8E93BD)),
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
