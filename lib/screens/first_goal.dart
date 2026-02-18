import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosary/enums/pillar_type.dart';
import 'package:rosary/route/route_helpers.dart';

import '../controllers/goal_controller.dart';
import '../controllers/pillar_controller.dart';
import '../widgets/motiv_label.dart';
import '../widgets/primary_button.dart';

class FirstGoalPage extends StatefulWidget {
  const FirstGoalPage({super.key});

  @override
  State<FirstGoalPage> createState() => _FirstGoalPageState();
}

class _FirstGoalPageState extends State<FirstGoalPage> {
  final PillarController pillarC = Get.find<PillarController>();

  final TextEditingController goalCtrl = TextEditingController();
  final GoalController _goalController = Get.find<GoalController>();

  PillarType? selectedPillar;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  String motivationStyle = "Firm & Encouraging";
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

    goalCtrl.text = "";
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
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [bgTop, bgMid, bgBottom],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              children: [
                // Top bar
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      color: Colors.white.withOpacity(0.95),
                    ),
                    const Spacer(),
                    const SizedBox(width: 44),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  "Set Your First Goal",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white.withOpacity(0.95),
                    letterSpacing: 0.2,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 1,
                      width: 120,
                      color: Colors.white.withOpacity(0.25),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.70),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      height: 1,
                      width: 120,
                      color: Colors.white.withOpacity(0.25),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Expanded card with scroll for keyboard
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x220E1330),
                          blurRadius: 22,
                          offset: Offset(0, 14),
                        ),
                      ],
                      border: Border.all(
                        color: Color(0xFFE8EAF6),
                        width: 1,
                      ),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
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
                                const MotivGoLabel("Pillar"),
                                const SizedBox(height: 8),
                                Obx(() {
                                  final available = pillarC.selected.isNotEmpty
                                      ? pillarC.selected.toList()
                                      : pillarC.desired.toList();

                                  if (available.isEmpty) {
                                    return _SelectField(
                                      value: "No pillars selected",
                                      onTap: () {},
                                    );
                                  }

                                  if (selectedPillar == null ||
                                      !available.contains(selectedPillar)) {
                                    selectedPillar = available.first;
                                  }

                                  return _SelectDropdown<PillarType>(
                                    value: selectedPillar!,
                                    items: available,
                                    labelBuilder: (p) => p.label,
                                    onChanged: (p) =>
                                        setState(() => selectedPillar = p),
                                  );
                                }),
                                const SizedBox(height: 14),
                                const MotivGoLabel("Schedule Date"),
                                const SizedBox(height: 8),
                                _SelectField(
                                  value: selectedDate == null
                                      ? "Select a date"
                                      : _formatDate(selectedDate!),
                                  onTap: _pickDate,
                                ),
                                const SizedBox(height: 14),
                                const MotivGoLabel("Schedule Time"),
                                const SizedBox(height: 8),
                                _SelectField(
                                  value: selectedTime == null
                                      ? "Select a time"
                                      : selectedTime!.format(context),
                                  onTap: _pickTime,
                                ),
                                const SizedBox(height: 14),
                                const MotivGoLabel("Motivation Style"),
                                const SizedBox(height: 8),
                                _SelectDropdown<String>(
                                  value: motivationStyle,
                                  items: const [
                                    "Gentle Encouragement",
                                    "Firm & Encouraging",
                                    "Affirmations",
                                    "Short Reflection",
                                    "Faith-based",
                                  ],
                                  labelBuilder: (s) => s,
                                  onChanged: (s) =>
                                      setState(() => motivationStyle = s),
                                ),
                                const SizedBox(height: 16),
                                const MotivGoLabel("Motivation Format"),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    _RadioChoice(
                                      label: "Text",
                                      selected: format == "Text",
                                      onTap: () =>
                                          setState(() => format = "Text"),
                                    ),
                                    const SizedBox(width: 18),
                                    _RadioChoice(
                                      label: "Audio",
                                      selected: format == "Audio",
                                      onTap: () =>
                                          setState(() => format = "Audio"),
                                    ),
                                    const Spacer(),
                                    Transform.scale(
                                      scale: 0.95,
                                      child: Switch(
                                        value: both,
                                        onChanged: (v) =>
                                            setState(() => both = v),
                                        activeColor: const Color(0xFF7A3DFF),
                                        activeTrackColor:
                                            const Color(0xFF7A3DFF)
                                                .withOpacity(0.25),
                                        inactiveThumbColor:
                                            const Color(0xFFB7B9D5),
                                        inactiveTrackColor:
                                            const Color(0xFFB7B9D5)
                                                .withOpacity(0.25),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                MotivGoPrimaryButton(
                                  text: "Save Goal",
                                  onPressed: _saveGoal,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------
  // All helper methods below (unchanged)
  // ---------------------------
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

  final motivationMap = {
    "Gentle Encouragement": "gentle",
    "Firm & Encouraging": "firm",
    "Affirmations": "affirmations",
    "Short Reflection": "reflective",
    "Faith-based": "faith",
  };

  void _saveGoal() async {
    final goalText = goalCtrl.text.trim();
    if (goalText.isEmpty) {
      Get.snackbar("Missing Goal", "Please enter your goal.");
      return;
    }
    if (selectedPillar == null) {
      Get.snackbar("Missing Pillar", "Please choose a pillar.");
      return;
    }
    if (selectedDate == null) {
      Get.snackbar("Missing Date", "Please select a schedule date.");
      return;
    }
    if (selectedTime == null) {
      Get.snackbar("Missing Time", "Please select a schedule time.");
      return;
    }

    final scheduledAt = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    _goalController
        .saveGoalAndUpdateUser(
      goalTitle: goalText,
      pillar: selectedPillar!.apiValue,
      scheduledAt: scheduledAt,
      motivationStyle: motivationMap[motivationStyle]!,
      format: format,
      faithToggle: both,
    )
        .then((res) {
      if (res.isSuccess) {
        Get.snackbar(
          "Saved",
          "Goal scheduled for ${_formatDateTime(scheduledAt)}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF2B2E5A),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 14,
          duration: const Duration(seconds: 3),
          icon: const Icon(
            Icons.check_circle_rounded,
            color: Color(0xFFFF8A3D),
          ),
        );
        Get.offAllNamed(RouteHelpers.dashboard);
      } else {}
    });
  }

  String _formatDate(DateTime d) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return "${months[d.month - 1]} ${d.day}, ${d.year}";
  }

  String _formatDateTime(DateTime d) {
    final h = d.hour.toString().padLeft(2, '0');
    final m = d.minute.toString().padLeft(2, '0');
    return "${_formatDate(d)} • $h:$m";
  }
}

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
