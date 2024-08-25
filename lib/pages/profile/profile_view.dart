import 'package:figenie/widgets/tour_card.dart';
import 'package:flutter/material.dart';
import 'package:figenie/consts.dart';
import 'package:figenie/pages/profile/profile_controller.dart';

class ProfileView extends StatefulWidget {
  final ProfileController state;

  const ProfileView(this.state, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: foregroundColor,
      body: Stack(
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
                        backgroundImage: NetworkImage(
                            widget.state.user?.profilePicture ?? ''),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      widget.state.user?.username ?? '',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      widget.state.user?.email ?? '',
                      style: const TextStyle(
                        color: textLightColor,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 35,
                          width: 50,
                          decoration: BoxDecoration(
                            color: foregroundColor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                widget.state.user?.points.toString() ?? "",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: secondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // const Text(
                        //   "points",
                        //   style: TextStyle(
                        //     fontSize: 18,
                        //     color: textLightColor,
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(secondaryColor),
                        foregroundColor:
                            WidgetStateProperty.all<Color>(backgroundColor),
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
                          Text(
                            " (${widget.state.user?.completedTours.length ?? 0})",
                            style: const TextStyle(
                                color: secondaryColor,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: widget.state.user?.completedTours.isEmpty ?? true
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/mascot_2.png",
                                      width: 216,
                                      height: 216,
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
                                itemCount:
                                    widget.state.user?.completedTours.length ??
                                        0,
                                itemBuilder: (context, index) {
                                  final tour =
                                      widget.state.user?.completedTours[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: TourCard(
                                      tour: tour!,
                                      user: widget.state.user!,
                                    ),
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
      ),
    );
  }
}
