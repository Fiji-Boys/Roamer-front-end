import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:figenie/consts.dart'; // Import your constants like foregroundColor, secondaryColor
import 'package:figenie/pages/profile/profile_controller.dart'; // Import your profile controller

class ProfileView extends StatefulWidget {
  final ProfileController state;

  const ProfileView(this.state, {Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late Stream<User?> _userStream;

  @override
  void initState() {
    super.initState();
    _userStream = widget.state.authStateChanges;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No user found'));
        } else {
          User? user = snapshot.data;
          return Container(
            color: foregroundColor,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(user!.photoURL ?? ''),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Welcome, ${user.displayName ?? "User"}',
                  style: const TextStyle(
                    color: textColor,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  user.email ?? '',
                  style: const TextStyle(
                    color: textLightColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(secondaryColor),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(backgroundColor),
                  ),
                  onPressed: widget.state.signOut,
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                    child: Text("Sign out"),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
