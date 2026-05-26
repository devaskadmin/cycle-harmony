class ReminderItem {
  const ReminderItem({
    required this.title,
    required this.enabled,
    required this.time,
    required this.description,
  });

  final String title;
  final bool enabled;
  final String time;
  final String description;

  ReminderItem copyWith({
    String? title,
    bool? enabled,
    String? time,
    String? description,
  }) {
    return ReminderItem(
      title: title ?? this.title,
      enabled: enabled ?? this.enabled,
      time: time ?? this.time,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'enabled': enabled,
        'time': time,
        'description': description,
      };

  factory ReminderItem.fromMap(Map<String, dynamic> map) => ReminderItem(
        title: map['title'] as String,
        enabled: map['enabled'] as bool,
        time: map['time'] as String,
        description: map['description'] as String? ?? '',
      );
}
