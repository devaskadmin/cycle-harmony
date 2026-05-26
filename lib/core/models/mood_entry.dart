class MoodEntry {
  const MoodEntry({
    required this.date,
    required this.mood,
    required this.symptoms,
  });

  final DateTime date;
  final String mood;
  final List<String> symptoms;

  Map<String, dynamic> toMap() => {
        'date': date.toIso8601String(),
        'mood': mood,
        'symptoms': symptoms,
      };

  factory MoodEntry.fromMap(Map<String, dynamic> map) => MoodEntry(
        date: DateTime.parse(map['date'] as String),
        mood: map['mood'] as String,
        symptoms: List<String>.from(map['symptoms'] as List<dynamic>),
      );
}
