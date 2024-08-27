import 'package:figenie/model/tour.dart';
import 'package:figenie/model/user.dart' as u;
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
final UserService user_service = UserService();

class ProfileController extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService();
  u.User? user;

  late List<Tour> tours = <Tour>[];

  User? auth_user;

  String? username;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProfileView(this);
  }

  Future<void> signOut() async {
    await _auth.signOut();
    user = null;
    setState(() {});
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
    if (auth_user != null) {
      await auth_user!.reload();
      auth_user = _auth.currentUser;
    }
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

    _auth.authStateChanges().listen((event) {
      setState(() {
        auth_user = event;
        getCompletedTours(auth_user!.uid);
      });
    });
    _fetchCurrentUser();
  }
}
