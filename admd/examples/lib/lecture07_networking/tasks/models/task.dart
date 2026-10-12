import 'package:json_annotation/json_annotation.dart';

import 'reading.dart';

part 'task.g.dart';

// An enum is written as its name: "pending", "done".
enum Status { pending, done }

// explicitToJson: toJson calls lastReading.toJson() instead of leaving the object in the map.
@JsonSerializable(explicitToJson: true)
class Task {
  Task({
    this.id,
    required this.title,
    required this.status,
    required this.dueAt,
    this.lastReading,
  });

  factory Task.fromJson(Json j) => _$TaskFromJson(j);

  // Assigned by the server, so a task that was not saved yet has none.
  @JsonKey(includeIfNull: false)
  final int? id;
  final String title;
  final Status status;
  // A DateTime travels as an ISO 8601 string.
  @JsonKey(name: 'due_at')
  final DateTime dueAt;
  // A nested object uses its own fromJson and toJson.
  @JsonKey(name: 'last_reading')
  final Reading? lastReading;

  Json toJson() => _$TaskToJson(this);
}
