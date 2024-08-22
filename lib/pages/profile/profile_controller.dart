import 'dart:developer' as dev;
import 'package:figenie/model/tour.dart';
import 'package:figenie/pages/profile/profile_view.dart';
import 'package:figenie/services/tour_service.dart';
import 'package:figenie/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:figenie/model/user.dart' as model_user;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfileController();
}

final TourService service = TourService();
// ignore: non_constant_identifier_names
final UserService user_service = UserService();

class ProfileController extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late List<Tour> tours = <Tour>[];

  User? auth_user;
  late model_user.User user;
  final UserService userService = UserService();

  String? username;
  @override
  Widget build(BuildContext context) {
    return ProfileView(this);
  }

  Future<void> getCompletedTours(String uid) async {
    try {
      List<Tour> completedTours = await user_service.getCompletedTours(uid);
      setState(() {
        tours = completedTours;
      });
    } catch (e) {
      // print('Error fetching completed tours: $e');
    }
  }

  Future<void> setUser() async {
    if (_auth.currentUser != null) {
      try {
        user = await userService.getCurrentUser();
      } catch (e) {
        dev.log(e.toString(), name: "GetCurrentUser");
      }
    }
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> reloadUser() async {
    if (auth_user != null) {
      await auth_user!.reload();
      auth_user = _auth.currentUser;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    auth_user = null;
  }

  @override
  void initState() {
    super.initState();

    _auth.authStateChanges().listen((event) {
      setState(() {
        auth_user = event;
        getCompletedTours(auth_user!.uid);
      });
    });
    // getTours();
    setUser();
  }
}
