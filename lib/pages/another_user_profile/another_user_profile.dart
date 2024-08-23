import 'package:figenie/consts.dart';
import 'package:figenie/model/tour.dart';
import 'package:figenie/services/tour_service.dart';
import 'package:figenie/services/user_service.dart';
import 'package:figenie/widgets/tour_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../model/user.dart';

class AnotherUserProfile extends StatefulWidget {
  final User user;

  const AnotherUserProfile({super.key, required this.user});

  @override
  State<AnotherUserProfile> createState() => _AnotherUserProfileState();
}

class _AnotherUserProfileState extends State<AnotherUserProfile> {
  final TourService tourService = TourService();
  final UserService userService = UserService();
  late List<Tour> tours = <Tour>[];
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
    ));
    getCompletedTours(widget.user.id);
  }

  Future<void> getCompletedTours(String uid) async {
    try {
      List<Tour> completedTours = await userService.getCompletedTours(uid);
      setState(() {
        tours = completedTours;
      });
    } catch (e) {
      // print('Error fetching completed tours: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: backgroundColor),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: [
                const SizedBox(height: 35),
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: textColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 50),
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 72,
                      backgroundColor: secondaryColor,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage:
                            NetworkImage(widget.user.profilePicture),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      widget.user.username,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      widget.user.email,
                      style: const TextStyle(
                        color: textLightColor,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12.0),
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
                          if (tours.isNotEmpty)
                            Text(
                              " (${tours.length})",
                              style: const TextStyle(
                                  color: secondaryColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                        ],
                      ),
                      // const SizedBox(height: 16),
                      Expanded(
                        child: tours.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/mascot_2.png",
                                      width: 296,
                                      height: 296,
                                    ),
                                    const SizedBox(height: 16.0),
                                    const Text(
                                      "This user hasn't completed any tours yet...",
                                      style: TextStyle(
                                          color: textLighterColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: tours.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: TourCard(tour: tours[index]),
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
