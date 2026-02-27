import 'package:flutter/material.dart';

enum PillarType {
  personalGrowth,
  healthFitness,
  spiritualGrowth,
  dailyLife,
  emotionalWellness,
  businessMoney,
  learningCareer,
}

extension PillarTypeExtension on PillarType {

  
  // -------------------------------------------------
  // ⭐ Human readable title
  // -------------------------------------------------
  String get label {
    switch (this) {
      case PillarType.personalGrowth:
        return "Personal Growth";

      case PillarType.healthFitness:
        return "Health & Fitness";

      case PillarType.spiritualGrowth:
        return "Spiritual Growth";

      case PillarType.dailyLife:
        return "Daily Life & Habits";

      case PillarType.emotionalWellness:
        return "Emotional & Mental Wellness";

      case PillarType.businessMoney:
        return "Business & Money";

      case PillarType.learningCareer:
        return "Learning & Career";
    }
  }

  // -------------------------------------------------
  // ⭐ Subtitle
  // -------------------------------------------------
  String get subtitle {
    switch (this) {
      case PillarType.personalGrowth:
        return "Improve your mindset and habits";

      case PillarType.healthFitness:
        return "Build strength and wellness";

      case PillarType.spiritualGrowth:
        return "Grow spiritually and reflect";

      case PillarType.dailyLife:
        return "Create better daily routines";

      case PillarType.emotionalWellness:
        return "Support emotional stability";

      case PillarType.businessMoney:
        return "Improve finances and business";

      case PillarType.learningCareer:
        return "Advance skills and career";
    }
  }

  // -------------------------------------------------
  // ⭐ Material Icon (Fast UI rendering)
  // -------------------------------------------------
  IconData get icon {
    switch (this) {
      case PillarType.personalGrowth:
        return Icons.psychology_rounded;

      case PillarType.healthFitness:
        return Icons.fitness_center_rounded;

      case PillarType.spiritualGrowth:
        return Icons.auto_awesome_rounded;

      case PillarType.dailyLife:
        return Icons.home_rounded;

      case PillarType.emotionalWellness:
        return Icons.favorite_rounded;

      case PillarType.businessMoney:
        return Icons.trending_up_rounded;

      case PillarType.learningCareer:
        return Icons.school_rounded;
    }
  }

  // -------------------------------------------------
  // ⭐ Optional Asset Icon (Use if you switch to PNG/SVG later)
  // -------------------------------------------------
  String get iconAsset {
    switch (this) {
      case PillarType.personalGrowth:
        return "assets/icon/personal.png";

      case PillarType.healthFitness:
        return "assets/icon/health.png";

      case PillarType.spiritualGrowth:
        return "assets/icon/spiritual.png";

      case PillarType.dailyLife:
        return "assets/icon/habit.png";

      case PillarType.emotionalWellness:
        return "assets/icon/wellness.png";

      case PillarType.businessMoney:
        return "assets/icon/business.png";

      case PillarType.learningCareer:
        return "assets/icon/learning.png";
    }
  }

  // -------------------------------------------------
  // ⭐ Pillar Primary Color (Useful for UI Themes)
  // -------------------------------------------------
  Color get color {
    switch (this) {
      case PillarType.personalGrowth:
        return const Color(0xFF6C63FF);

      case PillarType.healthFitness:
        return const Color(0xFFFF8A3D);

      case PillarType.spiritualGrowth:
        return const Color(0xFF7A3DFF);

      case PillarType.dailyLife:
        return const Color(0xFF3D9BFF);

      case PillarType.emotionalWellness:
        return const Color(0xFFE37A5C);

      case PillarType.businessMoney:
        return const Color(0xFF2FBF71);

      case PillarType.learningCareer:
        return const Color(0xFFFFC107);
    }
  }

  // -------------------------------------------------
  // ⭐ Gradient (Premium UI Ready)
  // -------------------------------------------------
  LinearGradient get gradient {
    switch (this) {
      case PillarType.personalGrowth:
        return const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF9B8CFF)],
        );

      case PillarType.healthFitness:
        return const LinearGradient(
          colors: [Color(0xFFFF8A3D), Color(0xFFFFB46A)],
        );

      case PillarType.spiritualGrowth:
        return const LinearGradient(
          colors: [Color(0xFF7A3DFF), Color(0xFFA57DFF)],
        );

      case PillarType.dailyLife:
        return const LinearGradient(
          colors: [Color(0xFF3D9BFF), Color(0xFF7FC3FF)],
        );

      case PillarType.emotionalWellness:
        return const LinearGradient(
          colors: [Color(0xFFE37A5C), Color(0xFFF0A18E)],
        );

      case PillarType.businessMoney:
        return const LinearGradient(
          colors: [Color(0xFF2FBF71), Color(0xFF6BE3A4)],
        );

      case PillarType.learningCareer:
        return const LinearGradient(
          colors: [Color(0xFFFFC107), Color(0xFFFFE082)],
        );
    }
  }

  // -------------------------------------------------
  // ⭐ API value (safe backend mapping)
  // -------------------------------------------------
  String get apiValue {
    switch (this) {
      case PillarType.personalGrowth:
        return "personal_growth";
      case PillarType.healthFitness:
        return "health_fitness";
      case PillarType.spiritualGrowth:
        return "spiritual_growth";
      case PillarType.dailyLife:
        return "daily_life";
      case PillarType.emotionalWellness:
        return "emotional_wellness";
      case PillarType.businessMoney:
        return "business_money";
      case PillarType.learningCareer:
        return "learning_career";
    }
  }
}

// -------------------------------------------------
// ⭐ Convert backend string → enum safely
// -------------------------------------------------
PillarType pillarFromApi(String value) {
  switch (value) {
    case "personal_growth":
      return PillarType.personalGrowth;
    case "health_fitness":
      return PillarType.healthFitness;
    case "spiritual_growth":
      return PillarType.spiritualGrowth;
    case "daily_life":
      return PillarType.dailyLife;
    case "emotional_wellness":
      return PillarType.emotionalWellness;
    case "business_money":
      return PillarType.businessMoney;
    case "learning_career":
      return PillarType.learningCareer;
    default:
      return PillarType.personalGrowth; // fallback
  }
}
