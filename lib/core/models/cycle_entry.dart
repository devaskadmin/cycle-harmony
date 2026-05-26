class CycleEntry {
  const CycleEntry({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.cycleLength,
    required this.periodLength,
    required this.ovulationDate,
    required this.fertilityStart,
    required this.fertilityEnd,
    this.notes = '',
  });

  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final int cycleLength;
  final int periodLength;
  final DateTime ovulationDate;
  final DateTime fertilityStart;
  final DateTime fertilityEnd;
  final String notes;

  DateTime get nextCycleDate => startDate.add(Duration(days: cycleLength));

  Map<String, dynamic> toMap() => {
        'id': id,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'cycleLength': cycleLength,
        'periodLength': periodLength,
        'ovulationDate': ovulationDate.toIso8601String(),
        'fertilityStart': fertilityStart.toIso8601String(),
        'fertilityEnd': fertilityEnd.toIso8601String(),
        'notes': notes,
      };

  factory CycleEntry.fromMap(Map<String, dynamic> map) => CycleEntry(
        id: map['id'] as String,
        startDate: DateTime.parse(map['startDate'] as String),
        endDate: DateTime.parse(map['endDate'] as String),
        cycleLength: map['cycleLength'] as int,
        periodLength: map['periodLength'] as int,
        ovulationDate: DateTime.parse(map['ovulationDate'] as String),
        fertilityStart: DateTime.parse(map['fertilityStart'] as String),
        fertilityEnd: DateTime.parse(map['fertilityEnd'] as String),
        notes: (map['notes'] as String?) ?? '',
      );
}
