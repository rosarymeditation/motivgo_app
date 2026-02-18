import 'package:hive/hive.dart';

part 'goal_occurrence_model.g.dart';

@HiveType(typeId: 2)
class GoalOccurrenceModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String userId;

  @HiveField(2)
  String goalId;

  @HiveField(3)
  String dateKey;

  @HiveField(4)
  DateTime scheduledAt;

  @HiveField(5)
  String status;

  @HiveField(6)
  DateTime? checkedInAt;

  @HiveField(7)
  String pillar;

  @HiveField(8)
  String motivationStyle;

  @HiveField(9)
  String format;

  @HiveField(10)
  bool faithToggle;

  @HiveField(11)
  String? messageText;

  @HiveField(12)
  String? audioUrl;

  @HiveField(13)
  DateTime createdAt;

  @HiveField(14)
  DateTime updatedAt;

  GoalOccurrenceModel({
    required this.id,
    required this.userId,
    required this.goalId,
    required this.dateKey,
    required this.scheduledAt,
    required this.status,
    this.checkedInAt,
    required this.pillar,
    required this.motivationStyle,
    required this.format,
    required this.faithToggle,
    this.messageText,
    this.audioUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GoalOccurrenceModel.fromJson(Map<String, dynamic> json) {
    return GoalOccurrenceModel(
      id: json["_id"],
      userId: json["userId"],
      goalId: json["goalId"],
      dateKey: json["dateKey"],
      scheduledAt: DateTime.parse(json["scheduledAt"]),
      status: json["status"],
      checkedInAt: json["checkedInAt"] != null
          ? DateTime.parse(json["checkedInAt"])
          : null,
      pillar: json["pillar"],
      motivationStyle: json["motivationStyle"],
      format: json["format"],
      faithToggle: json["faithToggle"] ?? false,
      messageText: json["messageText"],
      audioUrl: json["audioUrl"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
    );
  }
}
