import 'package:get/get.dart';

import '../enums/pillar_type.dart';

class PillarController extends GetxController {
  /// Selected pillars (observable list)
  final RxList<PillarType> selected = <PillarType>[].obs;

  /// Tier comes from user profile (API). Set it when user logs in/registers.
  final RxString tier = "free".obs; // "free" | "premium"

  /// Max allowed based on tier
  int get maxAllowed => tier.value == "premium" ? 999 : 2;

  var isForFirstGoal = true.obs;

  /// UI helper: show "2 selected" and "limit reached"
  int get count => selected.length;
  bool get limitReached =>
      tier.value != "premium" && selected.length >= maxAllowed;

  /// Check if a pillar is selected
  bool isSelected(PillarType p) => selected.contains(p);
  bool isImmutable(PillarType pillar) => immutablePillars.contains(pillar);

  /// Try add (returns true if added, false if blocked by limit)
  bool add(PillarType p) {
    if (selected.contains(p)) return true;
    if (selected.length >= maxAllowed) return false;
    selected.add(p);
    return true;
  }

  void setIsForFirstGoal(bool val) {
    isForFirstGoal.value = val;
  }

  /// Remove
  void remove(PillarType p) => selected.remove(p);

  /// Toggle (returns true if successful, false if blocked)
  bool toggle(PillarType p) {
    if (selected.contains(p)) {
      selected.remove(p);
      return true;
    }
    if (selected.length >= maxAllowed) return false;
    selected.add(p);
    return true;
  }

  /// If you allow selecting many in UI during onboarding:
  /// This does NOT block selection; it just stores "desired" choices.
  /// Then you can decide later what to keep.
  final RxList<PillarType> desired = <PillarType>[].obs;
  final immutablePillars = <PillarType>[].obs;

  void toggleDesired(PillarType p) {
    if (desired.contains(p)) {
      desired.remove(p);
    } else {
      desired.add(p);
    }
  }

  void setSelectedPillars(List<PillarType> pillars) {
    immutablePillars.value = [];
    desired.value = [];
    desired.addAll(pillars);
    immutablePillars.addAll(pillars);
    //selected.assignAll(pillars);
  }

  /// Commit desired -> selected based on tier limit
  void commitDesiredToSelected() {
    if (tier.value == "premium") {
      selected.assignAll(desired);
    } else {
      selected.assignAll(desired.take(maxAllowed));
    }
  }

  /// API payload (send to backend)
  List<String> toApi() => selected.map((e) => e.apiValue).toList();

  /// Load from backend strings
  void loadFromApi(List<String> values) {
    final list = values.map(pillarFromApi).toList();
    if (tier.value == "premium") {
      selected.assignAll(list);
    } else {
      selected.assignAll(list.take(maxAllowed));
    }
  }

  /// Convenience: readable labels for UI chips, summaries, etc.
  List<String> labels() => selected.map((e) => e.label).toList();

  /// Set tier after login/upgrade
  void setTier(String newTier) {
    tier.value = newTier;

    // If user downgraded to free, trim selection
    if (tier.value != "premium" && selected.length > maxAllowed) {
      selected.assignAll(selected.take(maxAllowed));
    }
  }

  void clearAll() {
    selected.clear();
    desired.clear();
  }
}
