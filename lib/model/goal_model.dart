import 'package:hive/hive.dart';

part 'goal_model.g.dart';

@HiveType(typeId: 1)
class GoalModel extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? userId;

  @HiveField(2)
  String? title;

  @HiveField(3)
  String? pillar;

  @HiveField(4)
  String? reminderTime;

  @HiveField(5)
  String? frequency;

  @HiveField(6)
  List<int>? customDays;

  @HiveField(7)
  DateTime? startDate;

  @HiveField(8)
  DateTime? endDate;

  @HiveField(9)
  String? motivationStyle;

  @HiveField(10)
  String? format;

  @HiveField(11)
  bool? faithToggle;

  @HiveField(12)
  bool? active;

  @HiveField(13)
  int? currentStreak;

  @HiveField(14)
  int? bestStreak;

  @HiveField(15)
  String? lastCompletedDateKey;

  GoalModel({
    this.id,
    this.userId,
    this.title,
    this.pillar,
    this.reminderTime,
    this.frequency = "daily",
    this.customDays,
    this.startDate,
    this.endDate,
    this.motivationStyle,
    this.format = "text",
    this.faithToggle = false,
    this.active = true,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.lastCompletedDateKey,
  });

  factory GoalModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return GoalModel();
    return GoalModel(
      id: json['_id']?.toString(),
      userId: json['userId']?.toString(),
      title: json['title']?.toString(),
      pillar: json['pillar']?.toString(),
      reminderTime: json['reminderTime']?.toString(),
      frequency: json['frequency']?.toString() ?? "daily",
      customDays: json['customDays'] is List
          ? List<int>.from((json['customDays'] as List).whereType<int>())
          : [],
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'].toString())
          : DateTime.now(),
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'].toString())
          : null,
      motivationStyle: json['motivationStyle']?.toString(),
      format: json['format']?.toString() ?? "text",
      faithToggle: json['faithToggle'] ?? false,
      active: json['active'] ?? true,
      currentStreak: json['currentStreak'] ?? 0,
      bestStreak: json['bestStreak'] ?? 0,
      lastCompletedDateKey: json['lastCompletedDateKey']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "userId": userId,
      "title": title,
      "pillar": pillar,
      "reminderTime": reminderTime,
      "frequency": frequency,
      "customDays": customDays,
      "startDate": startDate?.toIso8601String(),
      "endDate": endDate?.toIso8601String(),
      "motivationStyle": motivationStyle,
      "format": format,
      "faithToggle": faithToggle,
      "active": active,
      "currentStreak": currentStreak,
      "bestStreak": bestStreak,
      "lastCompletedDateKey": lastCompletedDateKey,
    };
  }
}
