import 'package:hive/hive.dart';

part 'motivation_content_model.g.dart';

@HiveType(typeId: 3)
class MotivationContentModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String pillar;

  @HiveField(2)
  String style;

  @HiveField(3)
  bool faithOnly;

  @HiveField(4)
  String? text;

  @HiveField(5)
  String? audioUrl;

  @HiveField(6)
  bool active;

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  DateTime updatedAt;

  MotivationContentModel({
    required this.id,
    required this.pillar,
    required this.style,
    required this.faithOnly,
    this.text,
    this.audioUrl,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MotivationContentModel.fromJson(Map<String, dynamic> json) {
    return MotivationContentModel(
      id: json["_id"],
      pillar: json["pillar"],
      style: json["style"],
      faithOnly: json["faithOnly"] ?? false,
      text: json["text"],
      audioUrl: json["audioUrl"],
      active: json["active"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
    );
  }
}
