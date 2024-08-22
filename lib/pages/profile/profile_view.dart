import 'package:figenie/widgets/tour_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:figenie/consts.dart';
import 'package:figenie/pages/profile/profile_controller.dart';

class ProfileView extends StatefulWidget {
  final ProfileController state;

  const ProfileView(this.state, {super.key});

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
              child: Text(
                'No user found',
                style: TextStyle(color: textColor),
              ),
            );
          } else {
            User? user = snapshot.data;

            return Stack(
              children: [
                Container(color: backgroundColor),
                Column(
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      "Profile",
                      style: TextStyle(color: textColor, fontSize: 28),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 72,
                            backgroundColor: secondaryColor,
                            child: CircleAvatar(
                              radius: 70,
                              backgroundImage:
                                  NetworkImage(user!.photoURL ?? ''),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            user.displayName ?? '',
                            style: const TextStyle(
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
                          const SizedBox(height: 12.0),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  secondaryColor),
                              foregroundColor: WidgetStateProperty.all<Color>(
                                  backgroundColor),
                            ),
                            onPressed: widget.state.signOut,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 12.0,
                              ),
                              child: Text("Sign out"),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          color: foregroundColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Completed Tours",
                                  style: TextStyle(
                                      color: textLightColor,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                if (widget.state.tours.isNotEmpty)
                                  Text(
                                    " (${widget.state.tours.length})",
                                    style: const TextStyle(
                                        color: secondaryColor,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: widget.state.tours.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/mascot_2.png",
                                            width: 250,
                                            height: 250,
                                          ),
                                          const SizedBox(height: 16.0),
                                          const Text(
                                            "You haven't completed any tours yet...",
                                            style: TextStyle(
                                                color: textLighterColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                      // physics: const BouncingScrollPhysics(),
                                      itemCount: widget.state.tours.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: TourCard(
                                              tour: widget.state.tours[index]),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
