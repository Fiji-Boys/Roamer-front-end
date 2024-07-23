import 'package:figenie/model/tour.dart';
import 'package:figenie/widgets/tour_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:figenie/consts.dart'; // Import your constants like foregroundColor, secondaryColor
import 'package:figenie/pages/profile/profile_controller.dart'; // Import your profile controller

class ProfileView extends StatefulWidget {
  final ProfileController state;

  const ProfileView(this.state, {super.key});

  @override
  // ignore: library_private_types_in_public_api
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
    return Scaffold(
      backgroundColor: foregroundColor,
      body: StreamBuilder<User?>(
        stream: _userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: secondaryColor,
              ),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text('No user found', style: TextStyle(color: textColor)),
            );
          } else {
            User? user = snapshot.data;

            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.all(10),
                  height: 205,
                  width: 400,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 83,
                                  backgroundColor: secondaryColor,
                                  child: CircleAvatar(
                                    radius: 80,
                                    backgroundImage:
                                        NetworkImage(user!.photoURL ?? ''),
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Username',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
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
                                    const SizedBox(height: 8.0),
                                    const Text(
                                      "Rank",
                                      style: TextStyle(
                                        color: secondaryColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    const Text(
                                      "Points",
                                      style: TextStyle(
                                        color: secondaryColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Container(
                //   decoration: BoxDecoration(
                //     color: backgroundColor,
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                //   height: 470,
                //   width: 400,
                //   margin: const EdgeInsets.all(10),
                //   padding: const EdgeInsets.all(16.0),
                //   child: SingleChildScrollView(
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         const Text(
                //           'Completed Tours',
                //           style: TextStyle(
                //             fontSize: 22,
                //             fontWeight: FontWeight.bold,
                //             color: textColor,
                //           ),
                //         ),
                //         Column(
                //           children: widget.state.tours
                //               .map((tour) => TourCard(tour: tour))
                //               .toList(),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
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
                        EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
                    child: Text("Sign out"),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
