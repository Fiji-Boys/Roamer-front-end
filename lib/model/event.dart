// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figenie/model/entity.dart';

enum EventType { art, music, sport, market, scavanger }

class Event implements Entity {
  String id;
  String name;
  String description;
  double longitude;
  double latitude;
  EventType type;
  DateTime startDate;
  DateTime endDate;

  Event(
      {required this.id,
      required this.name,
      required this.description,
      required this.longitude,
      required this.latitude,
      required this.startDate,
      required this.endDate,
      required this.type});

  Event.fromJson(Map<String, Object?> json)
      : this(
          id: json["id"]! as String,
          name: json["name"]! as String,
          description: json["description"]! as String,
          type: EventType.values.byName(json["type"]! as String),
          longitude: json["longitude"]! as double,
          latitude: json["latitude"]! as double,
          startDate: (json["startDate"]! as Timestamp).toDate(),
          endDate: (json["endDate"]! as Timestamp).toDate(),
        );

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.toString().split('.').last,
      'longitude': longitude,
      'latitude': latitude,
      'startDate': startDate.toUtc(),
      'endDate': endDate.toUtc()
    };
  }
}
