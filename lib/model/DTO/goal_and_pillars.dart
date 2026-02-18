import 'package:rosary/model/goal_model.dart';

import '../../enums/pillar_type.dart';

class UpdateUserWithGoalRequest {
  final GoalModel goal;
  final List<PillarType> focusPillars;
  final String timezone;

  UpdateUserWithGoalRequest({
    required this.goal,
    required this.focusPillars,
    required this.timezone,
  });

  Map<String, dynamic> toJson() => {
        "goal": goal.toJson(),
        "focusPillars": focusPillars.map((p) => p.apiValue).toList(),
        "timezone": timezone,
      };
}
