import 'package:flutter/foundation.dart';

import '../core/constants/app_constants.dart';
import '../core/models/reminder_item.dart';
import '../services/local_storage_service.dart';

class ReminderProvider extends ChangeNotifier {
  ReminderProvider(this._storageService);

  final LocalStorageService _storageService;

  bool _isLoaded = false;
  final List<ReminderItem> _reminders = <ReminderItem>[];

  bool get isLoaded => _isLoaded;
  List<ReminderItem> get reminders =>
      List<ReminderItem>.unmodifiable(_reminders);

  Future<void> init() async {
    if (_isLoaded) {
      return;
    }

    final data =
        await _storageService.readJson(AppConstants.reminderProviderKey);
    if (data != null) {
      final raw = (data['reminders'] as List<dynamic>? ?? <dynamic>[])
          .cast<Map<String, dynamic>>();
      _reminders
        ..clear()
        ..addAll(raw.map(ReminderItem.fromMap));
    }

    if (_reminders.isEmpty) {
      _reminders.addAll(const <ReminderItem>[
        ReminderItem(
          title: 'Period Start',
          enabled: true,
          time: '09:00',
          description: '1 day(s) before at 09:00',
        ),
        ReminderItem(
          title: 'Fertile Window',
          enabled: true,
          time: '08:30',
          description: 'On the day at 08:30',
        ),
        ReminderItem(
          title: 'Ovulation Day',
          enabled: true,
          time: '08:00',
          description: '1 day(s) before at 08:00',
        ),
      ]);
      await _persist();
    }

    _isLoaded = true;
    notifyListeners();
  }

  Future<void> toggleReminder(int index, bool enabled) async {
    if (index < 0 || index >= _reminders.length) {
      return;
    }

    _reminders[index] = _reminders[index].copyWith(enabled: enabled);
    await _persist();
    notifyListeners();
  }

  Future<void> addReminder(ReminderItem item) async {
    _reminders.add(item);
    await _persist();
    notifyListeners();
  }

  Future<void> _persist() async {
    await _storageService.saveJson(
      AppConstants.reminderProviderKey,
      {
        'reminders': _reminders.map((e) => e.toMap()).toList(),
      },
    );
  }
}
