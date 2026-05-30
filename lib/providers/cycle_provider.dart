import 'dart:math';

import 'package:flutter/foundation.dart';

import '../core/constants/app_constants.dart';
import '../core/models/cycle_entry.dart';
import '../core/utils/date_utils.dart';
import '../services/local_storage_service.dart';

class CycleProvider extends ChangeNotifier {
  CycleProvider(this._storageService);

  final LocalStorageService _storageService;

  bool _isLoaded = false;
  bool _isDarkMode = false;
  int _defaultCycleLength = 28;
  int _defaultPeriodLength = 5;

  final List<CycleEntry> _entries = <CycleEntry>[];
  final Map<String, String> _notesByDate = <String, String>{};

  bool get isLoaded => _isLoaded;
  bool get isDarkMode => _isDarkMode;
  int get defaultCycleLength => _defaultCycleLength;
  int get defaultPeriodLength => _defaultPeriodLength;
  bool get hasCycleSetup => _entries.isNotEmpty;
  List<CycleEntry> get entries => List<CycleEntry>.unmodifiable(_entries);

  CycleEntry? get currentCycle {
    if (_entries.isEmpty) {
      return null;
    }
    final sorted = [..._entries]
      ..sort((a, b) => b.startDate.compareTo(a.startDate));
    return sorted.first;
  }

  Future<void> init() async {
    if (_isLoaded) {
      return;
    }

    final data = await _storageService.readJson(AppConstants.cycleProviderKey);
    if (data != null) {
      _isDarkMode = (data['isDarkMode'] as bool?) ?? false;
      _defaultCycleLength = (data['defaultCycleLength'] as int?) ?? 28;
      _defaultPeriodLength = (data['defaultPeriodLength'] as int?) ?? 5;

      final rawEntries = (data['entries'] as List<dynamic>? ?? <dynamic>[])
          .cast<Map<String, dynamic>>();
      _entries
        ..clear()
        ..addAll(rawEntries.map(CycleEntry.fromMap));

      final rawNotes =
          (data['notesByDate'] as Map<String, dynamic>? ?? <String, dynamic>{});
      _notesByDate
        ..clear()
        ..addAll(rawNotes.map((k, v) => MapEntry(k, v.toString())));
    }

    _isLoaded = true;
    notifyListeners();
  }

  Future<void> logPeriodStart([DateTime? start]) async {
    final startDate = DateUtilsX.dateOnly(start ?? DateTime.now());
    _entries.add(
      _buildCycleEntry(
        startDate: startDate,
        cycleLength: _defaultCycleLength,
        periodLength: _defaultPeriodLength,
      ),
    );
    await _persist();
    notifyListeners();
  }

  Future<void> saveInitialCycleSetup({
    required DateTime lastPeriodStart,
    required int cycleLength,
    required int periodLength,
  }) async {
    _defaultCycleLength = cycleLength;
    _defaultPeriodLength = periodLength;
    _entries
      ..clear()
      ..add(
        _buildCycleEntry(
          startDate: DateUtilsX.dateOnly(lastPeriodStart),
          cycleLength: cycleLength,
          periodLength: periodLength,
        ),
      );
    await _persist();
    notifyListeners();
  }

  Future<void> updateDefaults({int? cycleLength, int? periodLength}) async {
    if (cycleLength != null && cycleLength >= 21 && cycleLength <= 40) {
      _defaultCycleLength = cycleLength;
    }
    if (periodLength != null && periodLength >= 2 && periodLength <= 10) {
      _defaultPeriodLength = periodLength;
    }
    await _persist();
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    await _persist();
    notifyListeners();
  }

  String noteForDate(DateTime date) =>
      _notesByDate[DateUtilsX.dateKey(date)] ?? '';

  Future<void> saveDateNote(DateTime date, String note) async {
    _notesByDate[DateUtilsX.dateKey(date)] = note;
    await _persist();
    notifyListeners();
  }

  int cycleDayFor(DateTime date) {
    final cycle = currentCycle;
    if (cycle == null) {
      return 1;
    }
    final day = DateUtilsX.dateOnly(date)
            .difference(DateUtilsX.dateOnly(cycle.startDate))
            .inDays +
        1;
    return max(1, day);
  }

  double cycleProgressFor(DateTime date) {
    final cycle = currentCycle;
    if (cycle == null) {
      return 0;
    }
    final day = cycleDayFor(date);
    return (day / cycle.cycleLength).clamp(0.0, 1.0);
  }

  bool isPeriodDay(DateTime date) {
    final cycle = currentCycle;
    if (cycle == null) {
      return false;
    }
    final d = DateUtilsX.dateOnly(date);
    return !d.isBefore(DateUtilsX.dateOnly(cycle.startDate)) &&
        !d.isAfter(DateUtilsX.dateOnly(cycle.endDate));
  }

  bool isOvulationDay(DateTime date) {
    final cycle = currentCycle;
    if (cycle == null) {
      return false;
    }
    return DateUtilsX.isSameDate(cycle.ovulationDate, date);
  }

  bool isFertileDay(DateTime date) {
    final cycle = currentCycle;
    if (cycle == null) {
      return false;
    }
    final d = DateUtilsX.dateOnly(date);
    return !d.isBefore(DateUtilsX.dateOnly(cycle.fertilityStart)) &&
        !d.isAfter(DateUtilsX.dateOnly(cycle.fertilityEnd));
  }

  String phaseForDate(DateTime date) {
    if (isPeriodDay(date)) {
      return 'Period';
    }
    if (isOvulationDay(date)) {
      return 'Ovulation';
    }
    if (isFertileDay(date)) {
      return 'Fertile';
    }
    return 'Normal';
  }

  String probabilityForDate(DateTime date) {
    final phase = phaseForDate(date);
    if (phase == 'Ovulation') {
      return 'very high';
    }
    if (phase == 'Fertile') {
      return 'high';
    }
    if (phase == 'Period') {
      return 'low';
    }
    return 'medium';
  }

  DateTime nextPeriodDate() {
    final cycle = currentCycle;
    return cycle?.nextCycleDate ??
        DateTime.now().add(Duration(days: _defaultCycleLength));
  }

  DateTime fertileStart() {
    final cycle = currentCycle;
    return cycle?.fertilityStart ??
        DateTime.now().add(Duration(days: _defaultCycleLength - 19));
  }

  DateTime fertileEnd() {
    final cycle = currentCycle;
    return cycle?.fertilityEnd ??
        DateTime.now().add(Duration(days: _defaultCycleLength - 13));
  }

  DateTime ovulationDate() {
    final cycle = currentCycle;
    return cycle?.ovulationDate ??
        DateTime.now().add(Duration(days: _defaultCycleLength - 14));
  }

  Future<void> _persist() async {
    await _storageService.saveJson(
      AppConstants.cycleProviderKey,
      {
        'isDarkMode': _isDarkMode,
        'defaultCycleLength': _defaultCycleLength,
        'defaultPeriodLength': _defaultPeriodLength,
        'entries': _entries.map((e) => e.toMap()).toList(),
        'notesByDate': _notesByDate,
      },
    );
  }

  CycleEntry _buildCycleEntry({
    required DateTime startDate,
    required int cycleLength,
    required int periodLength,
  }) {
    final periodEnd = startDate.add(Duration(days: periodLength - 1));
    final ovulationDate =
        startDate.add(Duration(days: cycleLength - 14));
    final fertilityStart = ovulationDate.subtract(const Duration(days: 5));
    final fertilityEnd = ovulationDate.add(const Duration(days: 1));

    return CycleEntry(
      id: startDate.millisecondsSinceEpoch.toString(),
      startDate: startDate,
      endDate: periodEnd,
      cycleLength: cycleLength,
      periodLength: periodLength,
      ovulationDate: ovulationDate,
      fertilityStart: fertilityStart,
      fertilityEnd: fertilityEnd,
      notes: '',
    );
  }
}
