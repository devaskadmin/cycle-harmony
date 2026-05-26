import 'package:flutter/foundation.dart';

import '../core/constants/app_constants.dart';
import '../core/models/mood_entry.dart';
import '../services/local_storage_service.dart';

class MoodProvider extends ChangeNotifier {
  MoodProvider(this._storageService);

  final LocalStorageService _storageService;

  bool _isLoaded = false;
  final List<MoodEntry> _entries = <MoodEntry>[];

  bool get isLoaded => _isLoaded;
  List<MoodEntry> get entries => List<MoodEntry>.unmodifiable(_entries);

  Future<void> init() async {
    if (_isLoaded) {
      return;
    }

    final data = await _storageService.readJson(AppConstants.moodProviderKey);
    if (data != null) {
      final raw = (data['entries'] as List<dynamic>? ?? <dynamic>[])
          .cast<Map<String, dynamic>>();
      _entries
        ..clear()
        ..addAll(raw.map(MoodEntry.fromMap));
    }

    _isLoaded = true;
    notifyListeners();
  }

  Future<void> addMoodEntry(MoodEntry entry) async {
    _entries.removeWhere(
      (e) =>
          e.date.year == entry.date.year &&
          e.date.month == entry.date.month &&
          e.date.day == entry.date.day,
    );
    _entries.add(entry);
    await _persist();
    notifyListeners();
  }

  Future<void> _persist() async {
    await _storageService.saveJson(
      AppConstants.moodProviderKey,
      {
        'entries': _entries.map((e) => e.toMap()).toList(),
      },
    );
  }
}
