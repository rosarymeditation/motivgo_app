import 'dart:convert';

/// Matches backend enum
enum SuggestionType {
  feature,
  improvement,
  bug,
  other,
}

/// Optional admin workflow enum
enum SuggestionStatus {
  newStatus,
  reviewing,
  planned,
  completed,
  rejected,
}

class SuggestionModel {
  final String? id;
  final SuggestionType type;
  final String title;
  final String description;
  final bool allowContact;
  final String? email;
  final String? userId;
  final SuggestionStatus? status;
  final String? priority;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SuggestionModel({
    this.id,
    required this.type,
    required this.title,
    required this.description,
    this.allowContact = false,
    this.email,
    this.userId,
    this.status,
    this.priority,
    this.createdAt,
    this.updatedAt,
  });

  // ================================
  // JSON → Model
  // ================================
  factory SuggestionModel.fromJson(Map<String, dynamic> json) {
    return SuggestionModel(
      id: json["_id"],
      type: _typeFromString(json["type"]),
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      allowContact: json["allowContact"] ?? false,
      email: json["email"],
      userId: json["user"],
      status: _statusFromString(json["status"]),
      priority: json["priority"],
      createdAt:
          json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null,
      updatedAt:
          json["updatedAt"] != null ? DateTime.parse(json["updatedAt"]) : null,
    );
  }

  // ================================
  // Model → JSON (for API POST)
  // ================================
  Map<String, dynamic> toJson() {
    return {
      "type": type.name,
      "title": title,
      "description": description,
      "allowContact": allowContact,
      "email": allowContact ? email : null,
    };
  }

  // ================================
  // Helpers
  // ================================
  static SuggestionType _typeFromString(String? value) {
    switch (value) {
      case "feature":
        return SuggestionType.feature;
      case "improvement":
        return SuggestionType.improvement;
      case "bug":
        return SuggestionType.bug;
      default:
        return SuggestionType.other;
    }
  }

  static SuggestionStatus? _statusFromString(String? value) {
    switch (value) {
      case "new":
        return SuggestionStatus.newStatus;
      case "reviewing":
        return SuggestionStatus.reviewing;
      case "planned":
        return SuggestionStatus.planned;
      case "completed":
        return SuggestionStatus.completed;
      case "rejected":
        return SuggestionStatus.rejected;
      default:
        return null;
    }
  }

  // ================================
  // Optional: CopyWith
  // ================================
  SuggestionModel copyWith({
    String? id,
    SuggestionType? type,
    String? title,
    String? description,
    bool? allowContact,
    String? email,
    String? userId,
    SuggestionStatus? status,
    String? priority,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SuggestionModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      allowContact: allowContact ?? this.allowContact,
      email: email ?? this.email,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
