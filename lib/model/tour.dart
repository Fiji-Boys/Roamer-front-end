// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:figenie/model/entity.dart';
import 'package:latlong2/latlong.dart';

import 'key_point.dart';

enum TourType { informational, story, secret, adventure }

class Tour implements Entity {
  String id;
  String name;
  String description;
  bool isStarted = false;
  bool isCompleted = false;
  List<KeyPoint> keyPoints;
  int nextKeyPoint = 0;
  int points;
  TourType type;

  Tour(
      {required this.id,
      required this.name,
      required this.description,
      required this.keyPoints,
      required this.type,
      required this.points});

  Tour.fromJson(Map<String, Object?> json)
      : this(
            id: json["id"]! as String,
            name: json["name"]! as String,
            description: json["description"]! as String,
            type: TourType.values.byName(json["type"]! as String),
            points: json["points"]! as int,
            keyPoints: []);

  LatLng getNextKeyPointLocation() {
    if (nextKeyPoint >= keyPoints.length) return keyPoints.last.getLocation();
    KeyPoint keyPoint = keyPoints[nextKeyPoint];
    return keyPoint.getLocation();
  }

  void startTour() {
    isStarted = true;
    isCompleted = false;
  }

  void abandonTour() {
    nextKeyPoint = 0;
    isStarted = false;
  }

  void completeTour() {
    isCompleted = true;
    nextKeyPoint = 0;
  }

  void completeKeyPoint() {
    if (++nextKeyPoint >= keyPoints.length) {
      completeTour();
      isStarted = false;
    }
  }

  LatLng getLocation() {
    return keyPoints.first.getLocation();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'points': points,
      'type': type.toString().split('.').last,
    };
  }
}
