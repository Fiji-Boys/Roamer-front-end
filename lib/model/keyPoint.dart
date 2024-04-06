// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:google_maps_flutter/google_maps_flutter.dart';

class KeyPoint {
  int id;
  String name;
  String description;
  List<String> images;
  double longitude;
  double latitude;

  KeyPoint({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.latitude,
    required this.longitude,
  });

  LatLng getLocation() {
    return LatLng(latitude, longitude);
  }
}