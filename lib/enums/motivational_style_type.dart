enum MotivationStyle {
  gentle,
  firm,
  affirmations,
  reflective,
  faith,
}
extension MotivationStyleExtension on MotivationStyle {
  String get apiValue {
    switch (this) {
      case MotivationStyle.gentle:
        return "gentle";
      case MotivationStyle.firm:
        return "firm";
      case MotivationStyle.affirmations:
        return "affirmations";
      case MotivationStyle.reflective:
        return "reflective";
      case MotivationStyle.faith:
        return "faith";
    }
  }

  String get label {
    switch (this) {
      case MotivationStyle.gentle:
        return "Gentle";
      case MotivationStyle.firm:
        return "Firm";
      case MotivationStyle.affirmations:
        return "Affirmations";
      case MotivationStyle.reflective:
        return "Reflective";
      case MotivationStyle.faith:
        return "Faith-Based";
    }
  }
}
