// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reading _$ReadingFromJson(Map<String, dynamic> json) => Reading(
  deviceId: json['device_id'] as String,
  tempC: (json['temp_c'] as num).toDouble(),
);

Map<String, dynamic> _$ReadingToJson(Reading instance) => <String, dynamic>{
  'device_id': instance.deviceId,
  'temp_c': instance.tempC,
};
