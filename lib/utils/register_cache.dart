import 'package:shared_preferences/shared_preferences.dart';

class CompletedRegisterPrefs {
  static const _keyHasRegistered = 'has_registered';

  /// Save the flag
  static Future<void> setHasCompletedReg(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHasRegistered, value);
  }

  /// Read the flag.
  /// Returns `false` if it hasn’t been saved yet.
  static Future<bool> hasCompletedReg() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyHasRegistered) ?? false;
  }

  /// Call this if you ever need to clear it.
  static Future<void> clearHasRegistered() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyHasRegistered);
  }
}
