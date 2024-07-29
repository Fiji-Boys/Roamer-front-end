import 'package:figenie/model/tour.dart';
import 'package:figenie/pages/profile/profile_view.dart';
import 'package:figenie/services/tour_service.dart';
import 'package:figenie/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  User? user;
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

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> reloadUser() async {
    if (user != null) {
      await user!.reload();
      user = _auth.currentUser;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    user = null;
  }

  @override
  void initState() {
    super.initState();

    _auth.authStateChanges().listen((event) {
      setState(() {
        user = event;
        getCompletedTours(user!.uid);
      });
    });
    // getTours();
  }
}
