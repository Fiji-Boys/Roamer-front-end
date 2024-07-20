import 'package:figenie/consts.dart';
import 'package:figenie/pages/profile/profile_controller.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  final ProfileController state;
  const ProfileView(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: foregroundColor,
      child: state.user == null
          ? const Text("Loading")
          : Column(
              children: [
                Image.network(state.user!.photoURL!),
                TextButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(secondaryColor),
                  ),
                  onPressed: state.signOut,
                  child: const Text(
                    "Sign out",
                    style: TextStyle(color: foregroundColor),
                  ),
                ),
              ],
            ),
    );
  }
}
