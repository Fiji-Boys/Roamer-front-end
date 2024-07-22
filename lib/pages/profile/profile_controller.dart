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
      });
    });
  }
}
