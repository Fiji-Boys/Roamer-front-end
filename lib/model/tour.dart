// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'key_point.dart';

class Tour {
  String name;
  String description;
  bool isStarted = false;
  bool isCompleted = false;
  List<KeyPoint> keyPoints;
  int nextKeyPoint = 0;

  Tour({
    required this.name,
    required this.description,
    required this.keyPoints,
  });

  LatLng getNextKeyPointLocation() {
    if (nextKeyPoint >= keyPoints.length) return keyPoints.last.getLocation();
    KeyPoint keyPoint = keyPoints[nextKeyPoint];
    return keyPoint.getLocation();
  }

  void startTour() {
    isStarted = true;
  }

  void completeTour() {
    debugPrint("completed");
    isCompleted = true;
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
}
