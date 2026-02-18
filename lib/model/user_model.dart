import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String? id; // Mongo _id

  @HiveField(1)
  String? email;

  @HiveField(2)
  String? tier; // free | premium

  @HiveField(3)
  String? timezone;

  @HiveField(4)
  String? defaultMotivationStyle;

  @HiveField(5)
  String? defaultFormat;

  @HiveField(6)
  List<String>? fcmTokens;

  @HiveField(7)
  DateTime? createdAt;

  @HiveField(8)
  DateTime? updatedAt;

  @HiveField(9)
  String? firstName;

  @HiveField(10)
  String? password;

  @HiveField(11)
  List<String>? focusPillars;

  @HiveField(12)
  bool? onboardingCompleted;

  UserModel({
    this.id,
    this.email,
    this.tier,
    this.timezone,
    this.defaultMotivationStyle,
    this.defaultFormat,
    this.fcmTokens,
    this.createdAt,
    this.updatedAt,
    this.firstName,
    this.password,
    this.focusPillars,
    this.onboardingCompleted,
  });

  factory UserModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return UserModel();

    return UserModel(
      id: json['id']?.toString() ?? json['id']?.toString(), // <-- fix here
      email: json['email']?.toString(),
      tier: json['tier']?.toString(),
      timezone: json['timezone']?.toString(),
      defaultMotivationStyle: json['defaultMotivationStyle']?.toString(),
      defaultFormat: json['defaultFormat']?.toString(),
      fcmTokens: json['fcmTokens'] is List
          ? List<String>.from((json['fcmTokens'] as List).whereType<String>())
          : [],
      focusPillars: json['focusPillars'] is List
          ? List<String>.from(
              (json['focusPillars'] as List).whereType<String>())
          : [],
      onboardingCompleted: json['onboardingCompleted'] is bool
          ? json['onboardingCompleted'] as bool
          : false,
      createdAt: _safeParseDate(json['createdAt']),
      updatedAt: _safeParseDate(json['updatedAt']),
      firstName: json['firstName']?.toString(),
      password: json['password']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "tier": tier,
      "timezone": timezone,
      "defaultMotivationStyle": defaultMotivationStyle,
      "defaultFormat": defaultFormat,
      "fcmTokens": fcmTokens ?? [],
      "focusPillars": focusPillars ?? [],
      "onboardingCompleted": onboardingCompleted ?? false,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
      "firstName": firstName,
      "password": password,
    };
  }

  static DateTime? _safeParseDate(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return null;
    }
  }
}
