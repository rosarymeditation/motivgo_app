import 'package:hive/hive.dart';

part 'goal_model.g.dart';

@HiveType(typeId: 1)
class GoalModel extends HiveObject {
  // ================= BASIC =================

  @HiveField(0)
  String? id;

  @HiveField(1)
  String? userId;

  @HiveField(2)
  String? title;

  @HiveField(3)
  String? pillar;

  // ================= SCHEDULING =================

  @HiveField(4)
  int? alarmId; // IMPORTANT for cancelling/updating alarm

  @HiveField(5)
  DateTime? scheduledAt; // used for one-time

  @HiveField(6)
  String? repeatType;
  // "none", "weekly", "monthly", "yearly"

  @HiveField(7)
  List<int>? weekdays;
  // 1=Mon ... 7=Sun (for weekly)

  @HiveField(8)
  int? dayOfMonth;
  // for monthly

  @HiveField(9)
  int? hour;

  @HiveField(10)
  int? minute;

  // ================= USER SETTINGS =================

  @HiveField(11)
  String? motivationStyle;

  @HiveField(12)
  String? format;

  @HiveField(13)
  bool? faithToggle;

  @HiveField(14)
  bool? active;

  // ================= STREAK =================

  @HiveField(15)
  int? currentStreak;

  @HiveField(16)
  int? bestStreak;

  @HiveField(17)
  String? lastCompletedDateKey;

  GoalModel({
    this.id,
    this.userId,
    this.title,
    this.pillar,
    this.alarmId,
    this.scheduledAt,
    this.repeatType = "none",
    this.weekdays,
    this.dayOfMonth,
    this.hour,
    this.minute,
    this.motivationStyle,
    this.format = "text",
    this.faithToggle = false,
    this.active = true,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.lastCompletedDateKey,
  });

  // ================= FROM JSON =================

  factory GoalModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return GoalModel();

    return GoalModel(
      id: json['_id']?.toString(),
      userId: json['userId']?.toString(),
      title: json['title']?.toString(),
      pillar: json['pillar']?.toString(),
      alarmId: json['alarmId'],
      scheduledAt: json['scheduledAt'] != null
          ? DateTime.tryParse(json['scheduledAt'])
          : null,
      repeatType: json['repeatType'] ?? "none",
      weekdays:
          json['weekdays'] != null ? List<int>.from(json['weekdays']) : [],
      dayOfMonth: json['dayOfMonth'],
      hour: json['hour'],
      minute: json['minute'],
      motivationStyle: json['motivationStyle'],
      format: json['format'] ?? "text",
      faithToggle: json['faithToggle'] ?? false,
      active: json['active'] ?? true,
      currentStreak: json['currentStreak'] ?? 0,
      bestStreak: json['bestStreak'] ?? 0,
      lastCompletedDateKey: json['lastCompletedDateKey'],
    );
  }

  // ================= TO JSON =================

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "userId": userId,
      "title": title,
      "pillar": pillar,
      "alarmId": alarmId,
      "scheduledAt": scheduledAt?.toIso8601String(),
      "repeatType": repeatType,
      "weekdays": weekdays,
      "dayOfMonth": dayOfMonth,
      "hour": hour,
      "minute": minute,
      "motivationStyle": motivationStyle,
      "format": format,
      "faithToggle": faithToggle,
      "active": active,
      "currentStreak": currentStreak,
      "bestStreak": bestStreak,
      "lastCompletedDateKey": lastCompletedDateKey,
    };
  }

  bool isDueToday() {
    if (active != true) return false; // skip inactive goals

    final now = DateTime.now();
    final todayWeekday = now.weekday; // 1=Mon ... 7=Sun (matches your schema)
    final todayDayOfMonth = now.day;

    switch (repeatType) {
      case "none":
        // One-time goal — due only on its scheduled date
        if (scheduledAt == null) return false;
        return _isSameDay(scheduledAt!, now);

      case "weekly":
        // Due if today's weekday is in the weekdays list
        if (weekdays == null || weekdays!.isEmpty) return false;
        return weekdays!.contains(todayWeekday);

      case "monthly":
        // Due if today's day-of-month matches
        if (dayOfMonth == null) return false;
        return dayOfMonth == todayDayOfMonth;

      case "yearly":
        // Due if today matches the month AND day of scheduledAt
        if (scheduledAt == null) return false;
        return scheduledAt!.month == now.month && scheduledAt!.day == now.day;

      default:
        return false;
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
  GoalModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? pillar,
    int? alarmId,
    DateTime? scheduledAt,
    String? repeatType,
    List<int>? weekdays,
    int? dayOfMonth,
    int? hour,
    int? minute,
    String? motivationStyle,
    String? format,
    bool? faithToggle,
    bool? active,
    int? currentStreak,
    int? bestStreak,
    String? lastCompletedDateKey,
  }) {
    return GoalModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      pillar: pillar ?? this.pillar,
      alarmId: alarmId ?? this.alarmId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      repeatType: repeatType ?? this.repeatType,
      weekdays: weekdays ?? this.weekdays,
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      motivationStyle: motivationStyle ?? this.motivationStyle,
      format: format ?? this.format,
      faithToggle: faithToggle ?? this.faithToggle,
      active: active ?? this.active,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      lastCompletedDateKey: lastCompletedDateKey ?? this.lastCompletedDateKey,
    );
  }
}
