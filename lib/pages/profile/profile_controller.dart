import 'package:figenie/pages/profile/profile_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfileController();
}

class ProfileController extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? user;

  @override
  Widget build(BuildContext context) {
    return ProfileView(this);
  }

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        user = event;
      });
    });
  }

  void signOut() {
    _auth.signOut();
  }
}
