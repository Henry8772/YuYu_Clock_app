final String tableEvents = 'events';

class EventFields {
  static final String id = '_id';
  static final int duration = 0;
}

class Event {
  final int? id;
  final int duration;

  const Event({
    this.id,
    required this.duration,
  })

  Map<String, Object?> toJson() => {
    EventFields.id = id,
    EventFields.duration = duration,
  };
}
