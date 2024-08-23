import 'package:figenie/model/user.dart' as u;
import 'package:figenie/pages/profile/profile_view.dart';
import 'package:figenie/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfileController();
}

class ProfileController extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService();
  u.User? user;

  @override
  Widget build(BuildContext context) {
    return ProfileView(this);
  }

  Future<void> signOut() async {
    await _auth.signOut();
    user = null;
    setState(() {});
  }

  Future<void> _fetchCurrentUser() async {
    try {
      user = await _userService.getCurrentUser();
      setState(() {});
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
  }
}
