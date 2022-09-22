final String tableEvents = 'events';

class EventFields {
  static final List<String> values = [id, duration, createTime];

  static final String id = '_id';
  static final String duration = 'duration';
  static final String createTime = 'time';
}

class Event {
  final int? id;
  final int duration;
  final DateTime createTime;

  const Event({
    this.id,
    required this.duration,
    required this.createTime,
  });

  Event copy({
    int? id,
    int? duration,
    DateTime? createTime,
  }) =>
      Event(
          id: id ?? this.id,
          duration: duration ?? this.duration,
          createTime: createTime ?? this.createTime);

  Map<String, Object?> toJson() => {
        'id': id,
        'duration': duration,
        'createdTime': createTime.toIso8601String(),
      };

  static Event fromJson(Map<String, Object?> json) => Event(
        id: json[EventFields.id] as int?,
        duration: json[EventFields.duration] as int,
        createTime: json[EventFields.createTime] as DateTime,
      );
}
