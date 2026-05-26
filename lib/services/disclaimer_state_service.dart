import 'package:shared_preferences/shared_preferences.dart';

import '../core/models/disclaimer_state.dart';

class DisclaimerStateService {
  static const String disclaimerAcceptedKey = 'disclaimerAccepted';
  static const String disclaimerAcceptedDateKey = 'disclaimerAcceptedDate';
  static const String disclaimerLastShownKey = 'disclaimerLastShown';
  static const String appFirstLaunchKey = 'appFirstLaunch';
  static const String disclaimerVersionKey = 'disclaimerVersion';

  Future<DisclaimerState> readState({required String currentVersion}) async {
    final prefs = await SharedPreferences.getInstance();
    return DisclaimerState(
      accepted: prefs.getBool(disclaimerAcceptedKey) ?? false,
      acceptedDate: _parseDateTime(prefs.getString(disclaimerAcceptedDateKey)),
      lastShown: _parseDateTime(prefs.getString(disclaimerLastShownKey)),
      version: prefs.getString(disclaimerVersionKey) ?? '',
      firstLaunchComplete: prefs.getBool(appFirstLaunchKey) ?? false,
    );
  }

  Future<void> markShown({required String currentVersion}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        disclaimerLastShownKey, DateTime.now().toIso8601String());
    await prefs.setString(disclaimerVersionKey, currentVersion);
  }

  Future<DisclaimerState> accept({required String currentVersion}) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().toIso8601String();

    await prefs.setBool(disclaimerAcceptedKey, true);
    await prefs.setBool(appFirstLaunchKey, true);
    await prefs.setString(disclaimerAcceptedDateKey, now);
    await prefs.setString(disclaimerLastShownKey, now);
    await prefs.setString(disclaimerVersionKey, currentVersion);

    return readState(currentVersion: currentVersion);
  }

  Future<DisclaimerState> reset({required String currentVersion}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(disclaimerAcceptedKey, false);
    await prefs.setBool(appFirstLaunchKey, false);
    await prefs.remove(disclaimerAcceptedDateKey);
    await prefs.remove(disclaimerLastShownKey);
    await prefs.setString(disclaimerVersionKey, currentVersion);

    return readState(currentVersion: currentVersion);
  }

  DateTime? _parseDateTime(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    return DateTime.tryParse(value);
  }
}
