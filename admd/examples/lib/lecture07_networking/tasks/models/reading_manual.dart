// Manual JSON parsing: fromJson and toJson written by hand.
// Run: dart run lib/lecture07_networking/tasks/models/reading_manual.dart

import 'dart:convert';

class Reading {
  final String deviceId;
  final double tempC;

  Reading({required this.deviceId, required this.tempC});

  factory Reading.fromJson(Map<String, dynamic> j) => Reading(
    deviceId: j['device_id'] as String,
    // A JSON number arrives as int when it has no fraction: 21 is an int, 21.5 a double.
    // num covers both.
    tempC: (j['temp_c'] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {'device_id': deviceId, 'temp_c': tempC};
}

void main() {
  // jsonDecode returns dynamic: a Map for an object, a List for an array.
  final decoded = jsonDecode('{"device_id": "kitchen", "temp_c": 21}');
  final reading = Reading.fromJson(decoded as Map<String, dynamic>);
  print('${reading.deviceId}: ${reading.tempC} °C');

  print(jsonEncode(reading.toJson()));

  // The cost of doing it by hand: a typo in a key compiles, and fails at run time.
  try {
    Reading.fromJson({'deviceId': 'kitchen', 'temp_c': 21});
  } catch (e) {
    print('wrong key: $e');
  }

  // So does a field the server sends with another type.
  try {
    Reading.fromJson({'device_id': 'kitchen', 'temp_c': '21'});
  } catch (e) {
    print('wrong type: $e');
  }
}
