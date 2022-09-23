final String tableEvents = 'events';

class EventFields {
  static final List<String> values = [id, duration, createdDate, createdTime];

  static final String id = '_id';
  static final String duration = 'duration';
  static final String createdDate = 'date';
  static final String createdTime = 'time';
}

class Event {
  final int? id;
  final int duration;
  final DateTime createdDate;
  final DateTime createdTime;

  const Event({
    this.id,
    required this.duration,
    required this.createdDate,
    required this.createdTime,
  });

  Event copy({
    int? id,
    int? duration,
    DateTime? createdDate,
    DateTime? createdTime,
  }) =>
      Event(
          id: id ?? this.id,
          duration: duration ?? this.duration,
          createdDate: createdDate ?? this.createdDate,
          createdTime: createdTime ?? this.createdTime);

  Map<String, Object?> toJson() => {
        'id': id,
        'duration': duration,
        'createdDate': createdDate.toIso8601String(),
        'createdTime': createdTime.toIso8601String(),
      };

  static Event fromJson(Map<String, Object?> json) => Event(
        id: json[EventFields.id] as int?,
        duration: json[EventFields.duration] as int,
        createdDate: json[EventFields.createdDate] as DateTime,
        createdTime: json[EventFields.createdTime] as DateTime,
      );
}
