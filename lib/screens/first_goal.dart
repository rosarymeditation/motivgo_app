import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosary/enums/pillar_type.dart';
import 'package:rosary/route/route_helpers.dart';
import 'package:rosary/utils/notification_service.dart';

import '../controllers/goal_controller.dart';
import '../controllers/pillar_controller.dart';
import '../enums/motivational_style_type.dart';
import '../enums/time_enum.dart';
import '../widgets/motiv_label.dart';
import '../widgets/primary_button.dart';

enum RepeatOption { none, weekly, monthly, yearly }

class FirstGoalPage extends StatefulWidget {
  const FirstGoalPage({super.key});

  @override
  State<FirstGoalPage> createState() => _FirstGoalPageState();
}

class _FirstGoalPageState extends State<FirstGoalPage> {
  final PillarController pillarC = Get.find<PillarController>();
  final GoalController _goalController = Get.find<GoalController>();

  final TextEditingController goalCtrl = TextEditingController();

  PillarType? selectedPillar;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  // 🔥 NEW FLEXIBLE SCHEDULING
  RepeatOption repeatOption = RepeatOption.none;
  final Set<int> selectedWeekdays = {}; // 1 = Monday ... 7 = Sunday
  int? monthlyDay;
MotivationStyle motivationStyle = MotivationStyle.gentle;

  //String motivationStyle = "Firm & Encouraging";
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
          "Set Your First Goal",
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
            const MotivGoLabel("Goal"),
            const SizedBox(height: 8),
            _TextFieldLike(
              controller: goalCtrl,
              hintText: "e.g. Wake up by 5am",
            ),
            const SizedBox(height: 14),

            // PILLAR
            const MotivGoLabel("Pillar"),
            const SizedBox(height: 8),
            _buildPillarDropdown(),

            const SizedBox(height: 14),

            // TIME
            const MotivGoLabel("Schedule Time"),
            const SizedBox(height: 8),
            _SelectField(
              value: selectedTime == null
                  ? "Select time"
                  : selectedTime!.format(context),
              onTap: _pickTime,
            ),

            const SizedBox(height: 16),

            // 🔥 REPEAT OPTIONS
            const MotivGoLabel("Repeat"),
            const SizedBox(height: 8),
            _buildRepeatSelector(),

            const SizedBox(height: 16),

            if (repeatOption == RepeatOption.weekly)
              _buildWeekdaySelector(),

            if (repeatOption == RepeatOption.monthly)
              _buildMonthlySelector(),

            if (repeatOption == RepeatOption.none)
              _buildOneTimeDate(),

            const SizedBox(height: 20),

            const MotivGoLabel("Motivation Style"),
            const SizedBox(height: 8),
            _buildMotivationDropdown(),

            const SizedBox(height: 20),

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
  // WEEKDAY SELECTOR (BEAUTIFUL CHIPS)
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
            final dayNumber = index == 0 ? 7 : index; // Sunday fix
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
                    color: selected
                        ? Colors.white
                        : const Color(0xFF2B2E5A),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildMonthlySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MotivGoLabel("Day of Month"),
        const SizedBox(height: 8),
        _SelectField(
          value: monthlyDay == null
              ? "Select day (1-31)"
              : "Day $monthlyDay",
          onTap: () async {
            final picked = await showDialog<int>(
              context: context,
              builder: (_) => _DayPickerDialog(),
            );
            if (picked != null) {
              setState(() => monthlyDay = picked);
            }
          },
        ),
      ],
    );
  }

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
      ],
    );
  }

  // ============================================================
  // SAVE GOAL (UNBROKEN LOGIC)
  // ============================================================

void _saveGoal() async {
    final goalText = goalCtrl.text.trim();

    if (goalText.isEmpty) {
      Get.snackbar("Missing Goal", "Please enter your goal.");
      return;
    }

    if (selectedTime == null) {
      Get.snackbar("Missing Time", "Please select time.");
      return;
    }

    // 🔥 Extra validation for repeat types
    if (repeatOption == RepeatOption.weekly && selectedWeekdays.isEmpty) {
      Get.snackbar("Missing Days", "Please select at least one weekday.");
      return;
    }

    if (repeatOption == RepeatOption.monthly && monthlyDay == null) {
      Get.snackbar("Missing Day", "Please select a day of month.");
      return;
    }

    DateTime? scheduledAt;

    if (repeatOption == RepeatOption.none) {
      if (selectedDate == null) {
        Get.snackbar("Missing Date", "Select date.");
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
      repeatType: repeatOption.name, // 🔥 IMPORTANT
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
      Get.offAllNamed(RouteHelpers.bottomNav);
    } else {
      Get.snackbar("Error", res.message);
    }
  }

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

  String _formatDate(DateTime d) {
    return "${d.day}/${d.month}/${d.year}";
  }

  Widget _buildPillarDropdown() {
    return Obx(() {
      final available = pillarC.selected.isNotEmpty
          ? pillarC.selected.toList()
          : pillarC.desired.toList();

      if (selectedPillar == null) {
        selectedPillar = available.first;
      }

      return _SelectDropdown<PillarType>(
        value: selectedPillar!,
        items: available,
        labelBuilder: (p) => p.label,
        onChanged: (p) => setState(() => selectedPillar = p),
      );
    });
  }

 Widget _buildMotivationDropdown() {
    return _SelectDropdown<MotivationStyle>(
      value: motivationStyle,
      items: MotivationStyle.values,
      labelBuilder: (style) => style.label,
      onChanged: (style) {
        if (style != null) {
          setState(() => motivationStyle = style);
        }
      },
    );
  }
}

// ============================================================
// DAY PICKER DIALOG
// ============================================================

class _DayPickerDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Select Day"),
      content: SizedBox(
        width: double.maxFinite,
        child: GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          children: List.generate(31, (index) {
            final day = index + 1;
            return InkWell(
              onTap: () => Navigator.pop(context, day),
              child: Center(child: Text("$day")),
            );
          }),
        ),
      ),
    );
  }
}

  // ---------------------------
  // All helper methods below (unchanged)
  // ---------------------------
  // Future<void> _pickDate() async {
  //   final now = DateTime.now();
  //   final picked = await showDatePicker(
  //     context: context,
  //     initialDate: selectedDate ?? now,
  //     firstDate: now,
  //     lastDate: DateTime(now.year + 5),
  //   );
  //   if (picked != null) setState(() => selectedDate = picked);
  // }


// ==========================
// Widgets used in page
// ==========================

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
        border: Border.all(
          color: const Color(0xFFE6E8F5),
          width: 1,
        ),
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
              .map(
                (e) => DropdownMenuItem<T>(
                  value: e,
                  child: Text(
                    labelBuilder(e),
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2B2E5A),
                    ),
                  ),
                ),
              )
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

  const _SelectField({
    required this.value,
    required this.onTap,
  });

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
          border: Border.all(
            color: const Color(0xFFE6E8F5),
            width: 1,
          ),
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

class _RadioChoice extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _RadioChoice({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected
                    ? const Color(0xFF7A3DFF)
                    : const Color(0xFFB7B9D5),
                width: 2,
              ),
            ),
            child: selected
                ? Center(
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF7A3DFF),
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14.2,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2B2E5A),
            ),
          ),
        ],
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
        border: Border.all(
          color: const Color(0xFFE6E8F5),
          width: 1,
        ),
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
