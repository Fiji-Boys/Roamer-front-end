// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:figenie/model/entity.dart';
import 'package:latlong2/latlong.dart';

class KeyPoint implements Entity {
  String name;
  String description;
  List<String> images;
  double longitude;
  double latitude;
  int order;

  KeyPoint({
    required this.name,
    required this.description,
    required this.images,
    required this.latitude,
    required this.longitude,
    required this.order,
  });

  KeyPoint.fromJson(Map<String, dynamic> json)
      : this(
            name: json['name'],
            description: json['description'],
            images: List<String>.from(json['images']),
            longitude: json['longitude'],
            latitude: json['latitude'],
            order: json['order']);

  LatLng getLocation() {
    return LatLng(latitude, longitude);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'images': images,
      'longitude': longitude,
      'latitude': latitude,
      'order': order,
    };
  }
}
