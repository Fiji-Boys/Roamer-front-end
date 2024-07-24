// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:figenie/model/entity.dart';
import 'package:figenie/model/tour.dart';

class User implements Entity {
  String id;
  String email;
  String username;
  int points;
  String profilePicture;
  List<Tour> completedTours;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.points,
    required this.profilePicture,
    required this.completedTours,
  });

  User.fromJson(Map<String, Object?> json)
      : this(
            id: json["id"]! as String,
            email: json["email"]! as String,
            points: json["points"] as int,
            profilePicture: json["profilePicture"]! as String,
            username: json["username"]! as String,
            completedTours: []);

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'points': points,
      'profilePicture': profilePicture,
      'completedTours': completedTours
    };
  }
}
