// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'keyPoint.dart';

class Tour {
  String name;
  String description;
  bool isStarted;
  List<KeyPoint> keyPoints;
  int currentKeyPoint = -1;

  Tour({
    required this.name,
    required this.description,
    required this.isStarted,
    required this.keyPoints,
  });

  LatLng getNextKeyPoint() {
    var nextKeyPoint =
        keyPoints.firstWhere((keyPoint) => keyPoint.id == currentKeyPoint + 1);
    currentKeyPoint = nextKeyPoint.id;
    return nextKeyPoint.getPosition();
  }

  void startTour() {
    isStarted = true;
    currentKeyPoint = 0;
  }
}
