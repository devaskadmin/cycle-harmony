import 'package:shared_preferences/shared_preferences.dart';

class DisclaimerService {
  static const String disclaimerAcceptedKey = 'disclaimerAccepted';

  Future<bool> isAccepted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(disclaimerAcceptedKey) ?? false;
  }

  Future<void> accept() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(disclaimerAcceptedKey, true);
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(disclaimerAcceptedKey);
  }
}
