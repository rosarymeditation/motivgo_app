import 'package:hive/hive.dart';
part 'goal_occurrence_model.g.dart';

@HiveType(typeId: 5)
enum GoalOccurrenceStatus {
  @HiveField(0)
  pending,
  @HiveField(1)
  completed,
  @HiveField(2)
  skipped,
}

@HiveType(typeId: 2)
class GoalOccurrence extends HiveObject {
  @HiveField(0)
  late String goalId;

  @HiveField(1)
  late String dateKey; // "YYYY-MM-DD"

  @HiveField(2)
  late DateTime scheduledAt;

  @HiveField(3)
  late GoalOccurrenceStatus status;

  @HiveField(4)
  DateTime? checkedInAt;

  @HiveField(5)
  String? pillar;

  @HiveField(6)
  String? motivationStyle;

  @HiveField(7)
  String? format;

  @HiveField(8)
  String? messageText;

  @HiveField(9)
  String? audioUrl;

  @HiveField(10)
  late DateTime createdAt;

  @HiveField(11)
  late DateTime updatedAt;

   @HiveField(12)
  String? goalTitle; // ✅ ADD THIS


  GoalOccurrence({
    required this.goalId,
    required this.dateKey,
    required this.scheduledAt,
    this.status = GoalOccurrenceStatus.pending,
    this.checkedInAt,
    this.pillar,
    this.motivationStyle,
    this.format,
    this.messageText,
    this.audioUrl,
     required this.goalTitle, 
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();


        Map<String, dynamic> toJson() {
    return {
      'goalId': goalId,
      'dateKey': dateKey,
      'goalTitle': goalTitle,
      'scheduledAt': scheduledAt.toIso8601String(),
      'status': status.name, // enum as String
      'checkedInAt': checkedInAt?.toIso8601String(),
      'pillar': pillar,
      'motivationStyle': motivationStyle,
      'format': format,
      'messageText': messageText,
      'audioUrl': audioUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
