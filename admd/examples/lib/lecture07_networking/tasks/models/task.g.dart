// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
  id: (json['id'] as num?)?.toInt(),
  title: json['title'] as String,
  status: $enumDecode(_$StatusEnumMap, json['status']),
  dueAt: DateTime.parse(json['due_at'] as String),
  lastReading: json['last_reading'] == null
      ? null
      : Reading.fromJson(json['last_reading'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
  'id': ?instance.id,
  'title': instance.title,
  'status': _$StatusEnumMap[instance.status]!,
  'due_at': instance.dueAt.toIso8601String(),
  'last_reading': instance.lastReading?.toJson(),
};

const _$StatusEnumMap = {Status.pending: 'pending', Status.done: 'done'};
